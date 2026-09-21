#!/usr/bin/env bash
# Phase 5 step 2: remove nix from mbp16. Run with sudo, AFTER darwin-uninstaller.
#
#   sudo ./phase5-teardown.sh
#
# Every step is guarded and skips work already done, so a half-failed run is
# safe to repeat. The only irreversible step is the last one, and it asks first.
set -euo pipefail

NIX_VOLUME_UUID=91E3BF7F-F6A7-4F2C-8796-3846574020BB
USER_HOME=$(eval echo "~${SUDO_USER:?run me with sudo, not as root directly}")

say() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }
skip() { printf '    (already done: %s)\n' "$1"; }

# --- guards --------------------------------------------------------------
# darwin-uninstaller must have run first. It owns /etc/pam.d/sudo_local and the
# shell files; running before it means fighting it for the same paths.
[[ $EUID -eq 0 ]] || { echo "run with sudo" >&2; exit 1; }

if [[ -e /run/current-system ]]; then
  echo "FAIL: /run/current-system still exists — run darwin-uninstaller first" >&2
  exit 1
fi
for p in activate-system darwin-store nix-optimise; do
  if [[ -e "/Library/LaunchDaemons/org.nixos.$p.plist" ]]; then
    echo "FAIL: org.nixos.$p.plist still present — darwin-uninstaller did not finish" >&2
    exit 1
  fi
done

# Confirm the shell survives before we delete the only copy of the store.
if ! sudo -u "$SUDO_USER" zsh -lic 'command -v /usr/bin/env' >/dev/null 2>&1; then
  echo "FAIL: a login zsh cannot find /usr/bin — check /etc/zprofile path_helper" >&2
  exit 1
fi

# --- 1. TouchID sudo, first, to keep the gap short -----------------------
# NOT via `mise bootstrap files apply`: under sudo $HOME is /var/root, so mise
# reads no config and reports success having written nothing.
say "TouchID sudo → /etc/pam.d/sudo_local"
if [[ -f /etc/pam.d/sudo_local && ! -L /etc/pam.d/sudo_local ]] \
   && grep -q pam_tid /etc/pam.d/sudo_local; then
  skip "real file with pam_tid"
else
  rm -f /etc/pam.d/sudo_local
  printf 'auth       sufficient     pam_tid.so\n' > /etc/pam.d/sudo_local
  chmod 0444 /etc/pam.d/sudo_local
fi

# --- 2. shell files back to their pre-nix originals ----------------------
# darwin-uninstaller restores *.before-nix-darwin (= the nix-installer version).
# *.backup-before-nix is the pristine Apple file underneath that.
say "restore /etc shell files"
for f in zshrc bashrc; do
  if [[ -f "/etc/$f.backup-before-nix" ]]; then
    mv -f "/etc/$f" "/etc/$f.pre-teardown.$(date +%s)" 2>/dev/null || true
    cp -p "/etc/$f.backup-before-nix" "/etc/$f"
    echo "    restored /etc/$f"
  else
    skip "/etc/$f has no .backup-before-nix"
  fi
done
# /etc/zshenv is a nix-darwin invention; macOS ships none, so there is nothing
# to restore — it just goes.
if [[ -e /etc/zshenv ]]; then rm -f /etc/zshenv; echo "    removed /etc/zshenv"; else skip "/etc/zshenv"; fi

# --- 3. nix daemon -------------------------------------------------------
say "stop and remove the nix daemon"
if [[ -e /Library/LaunchDaemons/org.nixos.nix-daemon.plist ]]; then
  launchctl bootout system/org.nixos.nix-daemon 2>/dev/null || true
  rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
else
  skip "nix-daemon plist"
fi

# --- 4. build users ------------------------------------------------------
say "remove _nixbld users and the nixbld group"
n=0
for u in $(dscl . -list /Users 2>/dev/null | grep '^_nixbld' || true); do
  dscl . -delete "/Users/$u"; n=$((n+1))
done
[[ $n -gt 0 ]] && echo "    removed $n users" || skip "_nixbld users"
if dscl . -read /Groups/nixbld >/dev/null 2>&1; then
  dscl . -delete /Groups/nixbld
else
  skip "nixbld group"
fi

# --- 5. synthetic.conf: drop the nix line only ---------------------------
# The `run private/var/run` line is separate. A stale /run symlink is harmless,
# and removing a line this script never audited is not worth the risk.
say "drop nix from /etc/synthetic.conf"
if [[ -f /etc/synthetic.conf ]] && grep -qE '^nix$' /etc/synthetic.conf; then
  cp -p /etc/synthetic.conf /etc/synthetic.conf.pre-teardown
  sed -i '' '/^nix$/d' /etc/synthetic.conf
  [[ -s /etc/synthetic.conf ]] || rm -f /etc/synthetic.conf
else
  skip "synthetic.conf nix line"
fi

# --- 6. fstab, via vifs as the file's own banner demands -----------------
say "drop the /nix mount from /etc/fstab"
if grep -q "$NIX_VOLUME_UUID" /etc/fstab 2>/dev/null; then
  EDITOR="sed -i '' '/$NIX_VOLUME_UUID/d'" vifs
else
  skip "fstab entry"
fi

# --- 7. leftover profiles and config -------------------------------------
say "remove nix profiles and /etc/nix"
rm -rf /etc/nix
for h in "$USER_HOME" /var/root; do
  rm -rf "$h/.nix-profile" "$h/.nix-defexpr" "$h/.nix-channels"
done
rm -f "$USER_HOME/repos/dotfiles/result"

# --- 8. the volume. Irreversible. ----------------------------------------
say "delete the Nix Store APFS volume"
if diskutil info "$NIX_VOLUME_UUID" >/dev/null 2>&1; then
  diskutil info "$NIX_VOLUME_UUID" | grep -E 'Volume Name|Device Identifier|Volume Used Space'
  printf '\nThis erases the volume. There is no undo. Type DELETE to continue: '
  read -r reply
  if [[ $reply == DELETE ]]; then
    diskutil unmountDisk force "$NIX_VOLUME_UUID" || true
    diskutil apfs deleteVolume "$NIX_VOLUME_UUID"
  else
    echo "    skipped — volume left in place, everything else is done"
  fi
else
  skip "volume $NIX_VOLUME_UUID"
fi

say "done — reboot, then verify"
cat <<'EOF'
    After the reboot, as your normal user:
      mise bootstrap files status     # sudo_local should read "applied"
      sudo -k && sudo true            # TouchID prompt, not a password prompt
      /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate   # want 2
      defaults read /Library/Preferences/com.apple.loginwindow GuestEnabled  # want 0
      defaults read /Library/Preferences/com.apple.SoftwareUpdate \
        AutomaticallyInstallMacOSUpdates                                # want 1
EOF
