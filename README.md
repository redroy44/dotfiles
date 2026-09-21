# dotfiles

| machine | managed by | config |
|---|---|---|
| mbp16 | **mise** | `mise.toml` + `dotfiles/` |
| mbp14, zp | nix | `flake.nix` + `nixpkgs/` |

`mise.toml` is the single source of truth for mbp16: tools, Homebrew packages,
casks, Mac App Store apps, macOS defaults and dotfile symlinks. See `HANDOFF.md`
for the nix → mise migration log and the phase 5 teardown plan.

## New machine

```sh
curl https://mise.run | sh
git clone git@github.com:redroy44/dotfiles.git ~/repos/dotfiles
mkdir -p ~/.config/mise
ln -sf ~/repos/dotfiles/mise.toml ~/.config/mise/config.toml
mise bootstrap --yes
```

`mise bootstrap` runs every phase in order. Check first with `--dry-run`; it
prints what each phase would do and changes nothing.

Casks and Mac App Store apps need real Homebrew, so install it before
bootstrapping if the machine has none. Everything else mise fetches itself.

### Piecemeal

Each phase stands alone. `status` reports, `apply` acts.

```sh
mise bootstrap repos apply       # clones oh-my-zsh + 2 plugins
mise bootstrap dotfiles apply    # links dotfiles/ into $HOME
mise bootstrap packages apply    # brew formulae, casks, Mac App Store apps
mise bootstrap macos defaults apply
mise bootstrap files apply       # /etc/pam.d/sudo_local (TouchID sudo) — needs root
mise install                     # the [tools] entries
```

Order matters in one place: `brew:mas` lives in `[bootstrap.packages]`, not
`[tools]`, because the `mas:` entries shell out to it and `[tools]` resolves
twelve steps later. A `[tools]` mas makes those apps report *skipped* instead of
failing, so a first run looks green with the apps missing.

## Updating packages

```sh
mise outdated          # what has moved
mise up                # upgrade + rewrite mise.lock
mise up <tool>         # just one
mise prune             # delete versions nothing declares
```

**Casks are the exception.** Real Homebrew owns them — mise sees their
`.metadata` receipts, counts them installed and leaves their lifecycle alone. So:

```sh
brew upgrade --cask
```

Taking real ownership would mean `brew uninstall --cask X` then installing via
mise, which replaces the app bundle and resets its Privacy & Security grants.
Not worth it; most of these casks self-update anyway.

## Lockfile

`mise.lock` pins versions and checksums for everything in `[tools]`. It is the
`flake.lock` successor and it is committed.

```sh
mise lock --global --platform macos-arm64            # refresh every tool
mise lock --global --platform macos-arm64 <tool>     # one tool
```

**Always pass `--platform`.** Without it `mise lock` resolves every platform it
knows about and sweeps roughly 180 windows/linux/baseline entries — about 1570
lines — into the lockfile of an Apple-Silicon-only config.

`mise up` maintains the lockfile on its own, so a manual `mise lock` is only for
repairing drift. If a partial edit ever leaves an orphaned
`[tools.X."platforms.…"]` section behind, delete every block for that tool and
re-lock it rather than patching by hand.

## Layout

```
mise.toml        everything declarative
mise.lock        pinned versions + checksums
dotfiles/        raw configs, symlinked into $HOME by the dotfiles phase
nvim/            neovim config (lazy.nvim)
flake.nix        nix, for mbp14 + zp only
nixpkgs/         nix machine + home-manager configs
HANDOFF.md       migration log, phase 5 plan
phase5-teardown.sh   removes nix from mbp16; run after darwin-uninstaller
```

## nix machines

```sh
darwin-rebuild switch --flake .#macbook-pro-14
```
