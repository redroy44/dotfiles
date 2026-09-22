# nix → mise migration — handoff

Branch: `mise-migration` (master untouched = full rollback path).
Scope: **mbp16 only**. mbp14 + zp stay on nix for now. Old x86 MBP: ignored permanently.

## Status: COMPLETE ✅ — nix removed from mbp16 on 2026-09-22

mbp16 runs on mise alone. nix and nix-darwin are gone: no `/nix` volume, no daemon,
no build users, no `/etc` management. `mise bootstrap --dry-run` converges on every
phase with no warnings — including `system files`, which mise could not touch until
nix-darwin released `/etc/pam.d/sudo_local`.

**This document is now history, not a plan.** The live instructions are in
`README.md`. mbp14 and zp are still nix machines and still use `flake.nix`.

| Commit | What |
|---|---|
| `1bc5683` | Phase 1: raw dotfiles extracted from home-manager, `[dotfiles]` map, omz clones |
| `53e7559` | Phase 2: 57 `[tools]` + 10 brew-backend packages, `mise.lock` |
| `1fcaf57` | Phase 3: home-manager removed from mbp16 flake config, cutover done |
| `379187e` | kitty restored as `brew-cask:` (was installed by hm, vanished at cutover) |
| `2995a7c` | Phase 4: 20 casks + 3 mas apps + 14 macOS defaults + TouchID file declared |
| `6778384` | Phase 4b staged: nix files stripped of everything mise owns |
| `da1729a` | kache + kondo, worktrunk shell init |

## Current architecture

- `mise.toml` (repo root) = single source of truth. Symlinked as global config:
  `~/.config/mise/config.toml -> ~/repos/dotfiles/mise.toml`
- `dotfiles/` = raw configs, symlinked into `$HOME` by `mise bootstrap dotfiles apply`
- `mise.lock` = pinned versions + checksums (flake.lock successor)
- oh-my-zsh + 2 plugins: git clones in `~/.oh-my-zsh` via `[bootstrap.repos]`
- brew-backend packages land in `/opt/homebrew` (mise installs bottles itself, no brew needed)
- Daily commands: `mise install` / `mise up` / `mise prune` /
  `mise bootstrap dotfiles|repos|packages apply|status`

## Known post-cutover items

- macOS may re-prompt Privacy permissions for kitty (the .app was replaced).
- Old terminal windows carry stale half-nix env — use fresh ones.
- `neofetch` → `fastfetch` (neofetch dead upstream). `tenv` dropped (mise does
  per-project terraform). terraform is now `latest` (1.16); pin per-project as needed.
- `sbt -java-home ~/.nix-profile` alias removed — mise sets `JAVA_HOME` (temurin-21).
- mcphub-nvim came from a flake input; now present via lazy.nvim at
  `~/.local/share/nvim/lazy/mcphub.nvim`. Verified after the soak, nothing to do.
- Soak-verified: atuin history db intact, gnupg 2.5.21 works. `~/.gnupg` holds **no
  keys** and `user.signingkey = 07A01229AAA846E1` in `dotfiles/gitconfig` is stale —
  nothing has been signed since 2022 and `commit.gpgsign` is unset, so this predates
  the migration. Import from backup or drop the config line.

## Phase 4 — done: system layer declared in mise.toml

Everything from `nixpkgs/darwin/macbook-pro-16/{configuration,settings}.nix` that mise
can express now lives in `mise.toml`. **Nothing was installed or overwritten** — every
entry converged as already-satisfied. The nix files were left untouched on purpose
(see "Phase 4 leftover" below).

Verified by `status`, not by `apply`:

- `mise bootstrap packages status` → 34/34 `installed`, 0 missing.
- `mise bootstrap macos defaults status` → 14/14 `set` (value *and* plist type match).
- `mise bootstrap --dry-run` (the whole composed flow) → every phase already-satisfied,
  only the expected `sudo_local` warning. Note the `post-defaults` `killall` hook fires
  on every run, even when no default changed — Dock/Finder just relaunch.

### Casks: real Homebrew stays the engine

All 20 declared casks (21 before the spark-app swap) have a Homebrew `.metadata` receipt and exactly one Caskroom version,
which mise documents as satisfying a `brew-cask:` entry **without taking ownership**.
So declaring them is inert: no re-download, no bundle swap, no Privacy & Security
(TCC) grants reset. `adopt = true` was deliberately *not* used — that is for
unmanaged bundles with no `.metadata`, and here it would only force a pointless
re-pour. The handoff's earlier "test ONE cask first" warning turned out to be moot.

Consequences to know:
- Upgrade casks with `brew upgrade --cask`. mise `upgrade` skips their lifecycle.
- nix-darwin's `onActivation.upgrade = true` auto-upgraded casks; that is gone.
  Cask upgrades are manual now (most are `auto-updates` casks that self-update anyway).
- Taking real ownership later = `brew uninstall --cask X` then install via mise.
  That replaces the bundle and *will* reset TCC grants. Phase 5 decision, not this one.

### macOS defaults: written raw, not via the curated sections

`[bootstrap.macos.dock]` / `[.finder]` sugar exists, but only covers part of what
`settings.nix` set, so it would have meant curated *and* raw entries in the same
domain. All 14 pairs are raw instead: one mechanism, a 1:1 transcription you can
diff against `settings.nix`, and no dependence on curated-section support in a
given mise version. `[bootstrap.hooks.post-defaults]` runs `killall Dock Finder`.

### TouchID sudo: declared, and it CANNOT move before phase 5

`[bootstrap.files."/etc/pam.d/sudo_local"]` is in `mise.toml`, but the path is a
symlink into the read-only nix store, so mise refuses to touch it:

```
mise WARN  would not change file:/etc/pam.d/sudo_local: current symlink mode 0755
           uid 0 gid 0, desired file mode 0444 (manual action required)
```

**Verified, and it corrects an earlier assumption in this doc:** dropping
`security.pam.services.sudo_local.touchIdAuth` from `settings.nix` does *not* release
the path. A `darwin-rebuild build` without it still produces
`/etc/pam.d/sudo_local` as a nix-store symlink — just pointing at an **empty file**.
So removing the option would break TouchID sudo *and* leave mise still unable to write
there. Worst of both.

`touchIdAuth = true` therefore stays in `settings.nix` until nix-darwin is gone.
`darwin-uninstaller` — which drops all nix-darwin `/etc` management — is the real
prerequisite, not the option. That is phase 5 step 1b. Password sudo is unaffected
throughout.

### Why `mas` is a brew package, not a `[tools]` entry

`mas:` packages shell out to the `mas` CLI, which must already be on PATH. But
`[bootstrap.packages]` is **step 2** of `mise bootstrap` and `[tools]` is **step 14** —
so a `[tools]` mas does not exist yet when its own packages resolve.

The failure mode is the quiet kind: mise does **not** error. A missing `mas` makes those
entries report as *skipped*, so a first bootstrap looks green while EasyRes and Battery
Monitor silently are not installed.

`"brew:mas"` sits in `[bootstrap.packages]` instead, the same phase as its consumers,
which mise orders brew → brew-cask → mas. One `mise bootstrap` now does the right thing
on a fresh machine. The cost is a brew formula instead of an aqua binary — worth it to
remove a silent-partial-success trap.

(Lockfile note: `mise lock --global` with no `--platform` sweeps in ~180
windows/linux/baseline entries — +1570 lines — for an Apple-Silicon-only config. Use
`mise lock --global --platform macos-arm64 <tool>`.)

### Not migratable (unchanged from before)

Sudo-domain settings; mise writes user defaults only. nix-darwin set these and they
survive until teardown — **re-verify by hand after Phase 5**, they are not declared
anywhere: app firewall (+ block all incoming), `loginwindow.GuestEnabled = false`,
`SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true`.

### Phase 4b — ACTIVATED 2026-09-08

The nix files were stripped of everything mise now owns and switched in as
generation 101 after a 7-day soak. The rebuilt closure was byte-identical to the
Sep 1 dress-rehearsal build, and the activation diff matched the table below
exactly. Post-switch: `sudo_local` unchanged (`pam_tid.so` intact), FiraCode faces
still served from `~/Library/Fonts` by the casks, `mas` now brew 7.0.0,
`mise bootstrap --dry-run` fully converged. This was a dress rehearsal: it proves mise alone carries the machine
*while rollback still works*, instead of finding out during phase 5 with the bridge
already burned.

What changed in the repo:
- `configuration.nix` — `fonts.packages` and the whole `homebrew` block removed.
- `settings.nix` — `NSGlobalDomain` / `dock` / `finder` removed. Kept: `loginwindow`,
  `SoftwareUpdate`, `applicationFirewall`, `primaryUser`, and `touchIdAuth` (see above).

`darwin-rebuild build` succeeds, and the complete activation diff is small and known:

```
Brewfile:             ε → ∅      (+ HOMEBREW_BUNDLE_FILE/_NO_LOCK drop out of /etc/zshenv)
fira-code:            6.2 → ∅            } both still supplied by the casks,
nerd-fonts-fira-code: 3.4.0+6.2 → ∅      } in ~/Library/Fonts
fira-code-symbols:    20160811 → ∅   ← the only real loss, deliberate
mas:                  2.2.2 → ∅     ← nix-darwin's own mas, replaced by brew:mas 7.0.0
```

`/etc/pam.d/sudo_local` is byte-identical between the two generations, and nix-darwin
does not revert the defaults it wrote — mise owns them now.

Activated with:

```sh
darwin-rebuild build --flake ~/repos/dotfiles#macbook-pro-16
sudo darwin-rebuild switch --flake ~/repos/dotfiles#macbook-pro-16
mise bootstrap --dry-run     # → everything already-satisfied ✅
```

Now use the machine for a few days before starting phase 5. Rollback is unchanged and
still valid: `git checkout master` + `darwin-rebuild switch`.

### Known gaps — deliberately not declared

- **`hurl`** — a Homebrew leaf declared in neither nix nor mise, installed by hand.
  Reviewed and deliberately ignored; it is in the mise registry (`hurl = "latest"`)
  if that ever changes.
- **`fira-code-symbols`** — reviewed, decided against re-installing. Still present at
  `/Library/Fonts/Nix Fonts/…-fira-code-symbols-20160811` (one file,
  `FiraCode-Regular-Symbol.otf`, **built 2016-08-11**) and it disappears with `/nix` at
  Phase 5. There is **no** Homebrew cask — `font-fira-code-symbols` does not exist — and
  its nix homepage is a GitHub issue comment (tonsky/FiraCode#211), so there is no
  reliable download either. It is the old hack that puts FiraCode ligature glyphs in the
  Unicode Private Use Area for use inside a *different* font; nothing here needs that.
  `dotfiles/kitty.conf` asks for `FiraCode Nerd Font Mono`, which the Nerd Font cask
  supplies with a much larger PUA set.

  If it is ever wanted back, do **not** try to re-download it — copy it out of the store
  before teardown and let `[dotfiles]` place it:

  ```sh
  cp "/Library/Fonts/Nix Fonts/06hcyqridwfbnr16s47sn7na59zryvkj-fira-code-symbols-20160811/share/fonts/opentype/FiraCode-Regular-Symbol.otf" dotfiles/
  ```

- **`cueitup`** — from `dhth/tap`, installed by real Homebrew, and commented out in
  `configuration.nix` so nix never managed it either. Briefly declared in Phase 4 along
  with the tap; both removed on request. Still installed — dropping a declaration does
  not uninstall — but real brew owns it and a fresh machine will not get it. Re-adding
  needs the `brew:cueitup` entry *and* a `[bootstrap.brew.taps]` line for `dhth/tap`
  (`https://github.com/dhth/homebrew-tap`).

### The spark-app trap — resolved

`configuration.nix` listed cask `spark-app` under `# Productivity`, evidently meaning
Readdle's Spark email client. It is not: `spark-app` is **Shadow Lab's keyboard shortcut
manager** (shadowlab.org). The nix config had been installing the wrong app for as long
as it existed, and the real email client was separately installed from the App Store:

| | version | last opened |
|---|---|---|
| `/Applications/Spark.app` (cask `spark-app`) | 3.3.2 | never (`null`) |
| `/Applications/Spark Desktop.app` (`mas:6445813049`) | 3.30.7 | in daily use |

Phase 4 therefore declares `mas:6445813049` and **not** `brew-cask:spark-app`.

`/Applications/Spark.app` is still installed and now undeclared — nothing was
uninstalled. Remove it by hand whenever convenient: `brew uninstall --cask spark-app`.

## Phase 5 — TODO: nix teardown (after the soak *and* after 4b is activated)

### Pre-flight — done 2026-09-21, all clear

13 days on generation 101. `mise bootstrap --dry-run` still converges fully.
Everything below was checked **while `/nix` still exists**, because none of it can
be checked after the volume is gone.

- **Shell survives the teardown.** `/etc/zshenv` is a nix-darwin file that sources
  `set-environment` from the store; it supplies `/usr/bin:/bin:/usr/sbin:/sbin`,
  which sit *after* the mise paths in the live `PATH`. macOS ships no `/etc/zshenv`,
  so darwin-uninstaller removes it rather than restoring one — the base PATH then
  comes back from `/etc/zprofile.before-nix-darwin`, which is present and does call
  `/usr/libexec/path_helper`. `dotfiles/zshenv` only ever appends to `$PATH`, so it
  needs that helper to run. Verified present, not assumed.
- **`/etc` backups all present**: `zprofile`, `zshrc`, `bashrc` each have a
  `.before-nix-darwin` copy.
- **terminfo**: `TERMINFO_DIRS` lists three store paths but ends with
  `/usr/share/terminfo`, and `TERMINFO` points into Ghostty's own bundle. No loss.
- **Store references outside nix**: one hit, `~/.config/kitty/kitty.conf.bak`. Dead
  file, ignore.
- **Sudo-domain settings** are now scripted, not hand-checked: `./bootstrap-sudo.sh
  --check` reports all four, and `sudo ./bootstrap-sudo.sh` applies them. Values on
  2026-09-21, all correct except TouchID which nix-darwin still owns:

  | setting | source of truth | value |
  |---|---|---|
  | firewall enabled | `socketfilterfw --getglobalstate` | on |
  | block all incoming | `socketfilterfw --getblockall` | on |
  | `com.apple.loginwindow GuestEnabled` | `defaults` | 0 |
  | `com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates` | `defaults` | 1 |

  **Do not read the firewall with `defaults read com.apple.alf globalstate`.** That
  plist is a 60-byte legacy stub and still reports `1` on this machine, whose
  firewall is on *and* blocking all incoming. `socketfilterfw` is authoritative.
  Enable and block-all are two separate setters; `--getglobalstate` only *prints*
  "State = 2" because it folds block-all into its own report.

### Steps — all done 2026-09-22

1. ✅ `darwin-uninstaller` (nix-darwin) — restores /etc shell files it manages.
1b. Immediately after: `mise bootstrap files apply` to write the real
   `/etc/pam.d/sudo_local` (TouchID sudo). This only becomes possible once
   darwin-uninstaller has dropped nix-darwin's /etc management — dropping the
   `touchIdAuth` option alone does not free the path (verified, see phase 4).
   Then re-verify the four sudo-domain settings listed under Phase 4.
2. nix itself: stop daemon launchd plists, remove `_nixbld*` users, `/etc/synthetic.conf`
   + fstab entries, restore `/etc/zshrc.backup-before-nix` et al., delete `/nix` APFS volume.
3. Repo cleanup — **done 2026-09-21, before the teardown, so it could be verified
   while `/nix` still existed.** The `macbook-pro-16` output and
   `nixpkgs/darwin/macbook-pro-16/` are gone. `flake.nix`, `flake.lock` and the rest
   of `nixpkgs/` **stay**: mbp14 and zp are still nix machines and share this flake.

   Verified by comparing flake output names before and after the edit —
   `darwinConfigurations` went from
   `[ MacBook-Pro-Piotr macbook-pro-14 macbook-pro-16 ]` to
   `[ MacBook-Pro-Piotr macbook-pro-14 ]`, and `homeConfigurations` did not change.

   **Pre-existing, not caused by this:** `macbook-pro-14` does not evaluate at all on
   nix-darwin 25.11. Three options were removed upstream and still sit in its config:
   `services.nix-daemon.enable`, `system.defaults.alf.globalstate` and
   `security.pam.enableSudoTouchIdAuth`. It failed the same way before and after the
   mbp16 removal. Fix it on mbp14, from mbp14 — mbp16 cannot build it after step 2.

   (Side note: nix-darwin deprecating `system.defaults.alf.globalstate` in favour of
   `networking.applicationFirewall.*` is the same legacy-key trap described in the
   pre-flight above.)
4. ✅ Point of no return — passed. Rollback now means reinstalling nix and rebuilding
   from `master` history.

### What actually happened

Both sudo steps ran clean apart from two script bugs, both found by checking real
state instead of trusting the plan:

- **`vifs` does not quote-process `$EDITOR`.** `EDITOR="sed -i '' '/UUID/d'" vifs`
  arrives as literal `''` arguments and dies with `vifs: editing error`. It needs a
  real executable script. `/etc/fstab` was never corrupted — vifs refused the edit.
- **The `/etc` restore step was a regression** and was deleted. darwin-uninstaller
  already leaves `zshrc`/`bashrc`/`zprofile` nix-free and *current*; copying
  `*.backup-before-nix` over them would have installed a 2024-vintage Apple zshrc.
- `org.nixos.darwin-store.plist` is the **installer's** volume mounter, not
  nix-darwin's. It must outlive the uninstaller and be removed with the volume, or
  it retries the mount at every boot forever.

Also swept afterwards: `~/.cache/nix` (271 MB) and `~/.local/state/nix`.

There is **no uninstaller** for the classic upstream macOS nix installer — checked,
no `/nix/receipt.json`, no `/nix/nix-installer`. `phase5-teardown.sh` is the manual
procedure from the manual with this machine's volume UUID baked in. Determinate
Systems' installer does ship `nix-installer uninstall`; prefer it if nix is ever
installed again, e.g. on mbp14.

### Verified after the reboot

| | |
|---|---|
| `/nix`, `/run`, `/etc/synthetic.conf` | gone |
| `Nix Store` APFS volume | gone; 95 GB free, was 48 GB |
| `/etc/fstab`, `/Library/LaunchDaemons` | no nix entries |
| `./bootstrap-sudo.sh --check` | all 5 correct, TouchID included |
| `mise bootstrap --dry-run` | every phase converged, zero warnings |
| tools | nvim, rg, starship, atuin all resolve to mise installs |

### Left to do

- **mbp14 does not evaluate** on nix-darwin 25.11 — three options removed upstream
  still in its config (`services.nix-daemon.enable`,
  `system.defaults.alf.globalstate`, `security.pam.enableSudoTouchIdAuth`). Pre-dates
  this work. Fix it *on mbp14*; mbp16 can no longer build it.
- Merge `mise-migration` into `master`. Keeping master as a rollback point stopped
  meaning anything the moment the volume was deleted.
- `phase5-teardown.sh` has done its job here. It is kept only as a starting point if
  mbp14 ever migrates — its volume UUID is hardcoded and machine-specific.

## Rollback (valid until Phase 5)

```sh
rm ~/.zshenv ~/.zshrc ~/.config/git/config ~/.config/git/ignore \
   ~/.config/kitty/kitty.conf ~/.config/kitty/kitty-theme.conf \
   ~/.config/starship.toml ~/.config/tmux/tmux.conf
git checkout master
sudo darwin-rebuild switch --flake ~/repos/dotfiles#macbook-pro-16
```

The `macbook-pro-16` output no longer exists on `mise-migration` — checking out
`master` is what brings it back, and `master` still carries the full pre-migration
config. Do not try this from the migration branch.

Everything is still in /nix/store — fast, offline. Do NOT run darwin-rebuild from
master casually while on mise (it re-activates home-manager on top of mise links).
mise nuke option: `rm -rf ~/.local/share/mise` + remove activate line from zshenv.
