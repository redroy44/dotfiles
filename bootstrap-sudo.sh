#!/usr/bin/env bash
# The part of the setup that mise cannot do: root-owned OS settings.
# mise writes *user* defaults only, so these three live here instead.
#
#   sudo ./bootstrap-sudo.sh            apply
#   ./bootstrap-sudo.sh --check         report only, no root needed
#
# Idempotent. Run it after `mise bootstrap` on a new machine, and again after
# the phase 5 nix teardown to confirm nothing was dropped on the way out.
set -euo pipefail

FW=/usr/libexec/ApplicationFirewall/socketfilterfw
ok=0; bad=0

chk() { # chk <label> <want> <got>
  if [[ "$2" == "$3" ]]; then printf '  ok    %-34s %s\n' "$1" "$3"; ok=$((ok+1))
  else printf '  WRONG %-34s want %s, got %s\n' "$1" "$2" "$3"; bad=$((bad+1)); fi
}

read_default() { defaults read "$1" "$2" 2>/dev/null || echo unset; }

# Echo on/off/error. An empty or failed socketfilterfw call must never fall
# through to "on" — that would report a disabled firewall as correct.
fw_state() { # fw_state <flag> <on-pattern>
  local out
  out=$("$FW" "$1" 2>/dev/null) || { echo error; return; }
  [[ -n $out ]] || { echo error; return; }
  if grep -qiE "$2" <<<"$out"; then echo on; else echo off; fi
}

# An active line only — a commented-out pam_tid is not TouchID sudo.
has_touchid() {
  [[ -f /etc/pam.d/sudo_local && ! -L /etc/pam.d/sudo_local ]] &&
    grep -qE '^[[:space:]]*auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so' \
      /etc/pam.d/sudo_local
}

check() {
  echo "root-owned settings:"
  # Firewall state must come from socketfilterfw, NOT from `defaults read
  # com.apple.alf globalstate`. That plist is a 60-byte legacy stub still
  # reading 1 on a machine whose firewall is on and blocking all incoming.
  chk "firewall enabled"   on "$(fw_state --getglobalstate 'State = [12]')"
  chk "block all incoming" on "$(fw_state --getblockall 'blocking all')"
  chk "guest account disabled"    0 "$(read_default /Library/Preferences/com.apple.loginwindow GuestEnabled)"
  chk "auto-install macOS updates" 1 "$(read_default /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates)"

  if has_touchid; then
    chk "TouchID sudo" present present
  else
    # A symlink here means nix-darwin still owns the path — see HANDOFF.md.
    chk "TouchID sudo" present "$([[ -L /etc/pam.d/sudo_local ]] && echo symlink || echo missing)"
  fi

  echo
  [[ $bad -eq 0 ]] && echo "all $ok correct" || echo "$bad of $((ok+bad)) need applying"
  return 0
}

if [[ ${1:-} == --check ]]; then check; [[ $bad -eq 0 ]] || exit 1; exit 0; fi

[[ $EUID -eq 0 ]] || { echo "run with sudo, or pass --check" >&2; exit 1; }

echo "before:"; check; echo

# --- firewall ------------------------------------------------------------
"$FW" --setglobalstate on >/dev/null
"$FW" --setblockall on >/dev/null

# --- login window --------------------------------------------------------
defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# --- software update -----------------------------------------------------
defaults write /Library/Preferences/com.apple.SoftwareUpdate \
  AutomaticallyInstallMacOSUpdates -bool true

# --- TouchID sudo --------------------------------------------------------
# /etc/pam.d/sudo already does `auth include sudo_local`; Apple ships only a
# .template. Declared in mise.toml too, but `mise bootstrap files apply` cannot
# do it: under sudo $HOME is /var/root, so mise loads no config and writes
# nothing while reporting success.
if [[ -L /etc/pam.d/sudo_local ]]; then
  echo "SKIP TouchID: /etc/pam.d/sudo_local is a symlink (nix-darwin still owns it)" >&2
elif has_touchid; then
  :   # already correct
else
  # The file may carry unrelated admin PAM rules. Keep a copy before writing,
  # and prepend rather than truncate so those rules survive — pam_tid must come
  # first to be reached.
  if [[ -s /etc/pam.d/sudo_local ]]; then
    bak=/etc/pam.d/sudo_local.bak.$(date +%s)
    cp -p /etc/pam.d/sudo_local "$bak"
    echo "    kept existing rules, backup at $bak"
    { printf 'auth       sufficient     pam_tid.so\n'; cat "$bak"; } \
      > /etc/pam.d/sudo_local
  else
    printf 'auth       sufficient     pam_tid.so\n' > /etc/pam.d/sudo_local
  fi
  chmod 0444 /etc/pam.d/sudo_local
fi

ok=0; bad=0
echo; echo "after:"; check
[[ $bad -eq 0 ]] || exit 1
