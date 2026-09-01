# nix → mise migration — handoff

Branch: `mise-migration` (master untouched = full rollback path).
Scope: **mbp16 only**. mbp14 + zp stay on nix for now. Old x86 MBP: ignored permanently.

## Status: Phase 4 of 5 complete ✅

mbp16 runs on mise: tools from `mise.toml`, dotfiles symlinked from `dotfiles/`,
home-manager removed from the flake. Casks, Mac App Store apps and macOS defaults
are now declared in `mise.toml` too — but nix-darwin is still *installed* and still
the thing that actually applied the defaults. Phase 5 removes it.

| Commit | What |
|---|---|
| `1bc5683` | Phase 1: raw dotfiles extracted from home-manager, `[dotfiles]` map, omz clones |
| `53e7559` | Phase 2: 57 `[tools]` + 10 brew-backend packages, `mise.lock` |
| `1fcaf57` | Phase 3: home-manager removed from mbp16 flake config, cutover done |
| `379187e` | kitty restored as `brew-cask:` (was installed by hm, vanished at cutover) |
| `2995a7c` | Phase 4: 20 casks + 2 mas apps + 14 macOS defaults + TouchID file declared |

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
- mcphub-nvim came from a flake input; if nvim misses it, wire it into the packer
  config in `nvim/.config/nvim` instead.
- Watch out for: gpg signing (new gnupg 2.5.21 from brew backend), atuin history db,
  anything that cached nix store paths.

## Phase 4 — done: system layer declared in mise.toml

Everything from `nixpkgs/darwin/macbook-pro-16/{configuration,settings}.nix` that mise
can express now lives in `mise.toml`. **Nothing was installed or overwritten** — every
entry converged as already-satisfied. The nix files were left untouched on purpose
(see "Phase 4 leftover" below).

Verified by `status`, not by `apply`:

- `mise bootstrap packages status` → 33/33 `installed`, 0 missing.
- `mise bootstrap macos defaults status` → 14/14 `set` (value *and* plist type match).
- `mise bootstrap --dry-run` (the whole composed flow) → every phase already-satisfied,
  only the expected `sudo_local` warning. Note the `post-defaults` `killall` hook fires
  on every run, even when no default changed — Dock/Finder just relaunch.

### Casks: real Homebrew stays the engine

All 20 casks have a Homebrew `.metadata` receipt and exactly one Caskroom version,
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

### TouchID sudo: declared, intentionally not applied

`[bootstrap.files."/etc/pam.d/sudo_local"]` is in the config, but `/etc/pam.d/sudo_local`
is currently a **symlink into the read-only nix store**, owned by nix-darwin. mise
detects the type mismatch and refuses to touch it:

```
mise WARN  would not change file:/etc/pam.d/sudo_local: current symlink mode 0755
           uid 0 gid 0, desired file mode 0444 (manual action required)
```

That is the desired outcome — the declaration is inert until nix-darwin is gone, and
mise enforces it rather than a comment. TouchID sudo keeps working meanwhile. Apply it
in Phase 5 right after `darwin-uninstaller`. Not a lockout risk either way: password
sudo still works if TouchID lapses.

### The weird thing about `mas`

mise's `mas:` package manager shells out to the `mas` CLI, which must already be on
PATH. But `[bootstrap.packages]` is **step 2** of `mise bootstrap` and `[tools]` — where
`mas` is declared — is **step 14**. So on a fresh machine `mas` does not exist yet when
its own packages are resolved.

The failure mode is the nasty kind: mise does **not** error. A missing `mas` makes those
entries report as *skipped*, so a first bootstrap looks green while EasyRes and Battery
Monitor silently aren't there. A second `mise bootstrap` installs them. Hence the
doubled command in the README.

It looks fine on this machine only because `mas` is already installed. If that ordering
ever matters more, the fix is `brew:mas` in `[bootstrap.packages]` instead of `mas` in
`[tools]` — same phase as its consumers — at the cost of a brew formula over an aqua
binary. Not worth it for two App Store apps today.

`mas` is locked for `macos-arm64` only. `mise lock --global` with no `--platform` sweeps
in ~180 windows/linux/baseline entries (+1570 lines) for an Apple-Silicon-only config —
use `mise lock --global --platform macos-arm64 <tool>`.

### Not migratable (unchanged from before)

Sudo-domain settings; mise writes user defaults only. nix-darwin set these and they
survive until teardown — **re-verify by hand after Phase 5**, they are not declared
anywhere: app firewall (+ block all incoming), `loginwindow.GuestEnabled = false`,
`SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true`.

### Phase 4 leftover — your call, not done

The nix files still contain the now-duplicated `homebrew`, `system.defaults` and
`security.pam` blocks. Stripping them + `darwin-rebuild switch` is the Phase-3-shaped
other half and was **not** done unasked. If you want it: removing
`security.pam.services.sudo_local.touchIdAuth` and rebuilding deletes the
`/etc/pam.d/sudo_local` symlink, so `mise bootstrap files apply` needs to land right
after, or TouchID sudo stops working until it does.

### Known gaps — deliberately not declared

Four things exist on this machine that `mise.toml` does not manage. None are bugs;
they are all "a fresh machine would not get this", recorded so that is a decision
rather than a surprise.

- **`fira-code-symbols`** — came from nix `fonts.packages` and has no cask equivalent.
  The two font casks cover FiraCode itself and the Nerd Font patch, *not* the symbols
  package. If glyphs go missing in a terminal or editor after Phase 5, this is why.
- **`hurl`** — a Homebrew leaf declared in neither nix nor mise. Installed by hand at
  some point. One line (`hurl = "latest"`, it is in the mise registry) if you want it
  to survive.
- **`spark-app`** — installed twice over: the cask *and* Spark Desktop from the Mac App
  Store (`mas:6445813049`). Only the cask is declared. Worth picking one.
- **`cueitup`** — from `dhth/tap`, installed by real Homebrew, and commented out in
  `configuration.nix` so nix never managed it either. Was briefly declared in Phase 4
  along with the tap; both were removed on request. Still installed — dropping the
  declaration does not uninstall anything — but real brew owns it and a fresh machine
  will not get it. Re-add needs both the `brew:cueitup` entry and a
  `[bootstrap.brew.taps]` line for `dhth/tap` (`https://github.com/dhth/homebrew-tap`).

## Phase 5 — TODO: nix teardown (only after 1–2 weeks of soak)

1. `darwin-uninstaller` (nix-darwin) — restores /etc shell files it manages.
1b. Immediately after: `mise bootstrap files apply` to write the real
   `/etc/pam.d/sudo_local` (TouchID sudo) now that the nix symlink is gone,
   then re-verify the four sudo-domain settings listed under Phase 4.
2. nix itself: stop daemon launchd plists, remove `_nixbld*` users, `/etc/synthetic.conf`
   + fstab entries, restore `/etc/zshrc.backup-before-nix` et al., delete `/nix` APFS volume.
3. Repo cleanup: delete `flake.nix`, `flake.lock`, `nixpkgs/` **except** keep mbp14/zp parts
   if that machine hasn't migrated yet. Drop `nh`, `nix-search-cli` mentions.
4. Point of no return — after this, rollback = reinstall nix + rebuild from master history.

## Rollback (valid until Phase 5)

```sh
rm ~/.zshenv ~/.zshrc ~/.config/git/config ~/.config/git/ignore \
   ~/.config/kitty/kitty.conf ~/.config/kitty/kitty-theme.conf \
   ~/.config/starship.toml ~/.config/tmux/tmux.conf
git checkout master
sudo darwin-rebuild switch --flake ~/repos/dotfiles#macbook-pro-16
```

Everything is still in /nix/store — fast, offline. Do NOT run darwin-rebuild from
master casually while on mise (it re-activates home-manager on top of mise links).
mise nuke option: `rm -rf ~/.local/share/mise` + remove activate line from zshenv.
