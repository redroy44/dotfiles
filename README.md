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
sudo ./bootstrap-sudo.sh
```

`mise bootstrap` runs every phase in order. Check first with `--dry-run`; it
prints what each phase would do and changes nothing.

`bootstrap-sudo.sh` covers what mise cannot: mise writes *user* defaults only,
so the root-owned settings live in that script — application firewall, block all
incoming, guest account off, auto-install macOS updates, and TouchID sudo.
It is idempotent, and `./bootstrap-sudo.sh --check` reports without applying
anything or needing root.

Casks and Mac App Store apps need real Homebrew, so install it before
bootstrapping if the machine has none. Everything else mise fetches itself.

### Piecemeal

Each phase stands alone. `status` reports, `apply` acts.

```sh
mise bootstrap repos apply       # clones oh-my-zsh + 2 plugins
mise bootstrap dotfiles apply    # links dotfiles/ into $HOME
mise bootstrap packages apply    # brew formulae, casks, Mac App Store apps
mise bootstrap macos defaults apply
mise install                     # the [tools] entries
sudo ./bootstrap-sudo.sh         # root-owned OS settings
```

Note `mise bootstrap files apply` is *not* in that list. It declares
`/etc/pam.d/sudo_local`, but under `sudo` mise sees `$HOME=/var/root`, loads no
config and writes nothing while reporting success. `bootstrap-sudo.sh` writes
that file directly.

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

There is **one** lockfile and it lives in this repo. `~/.config/mise/config.toml`
is a symlink to `mise.toml` here, and the mise docs say the lockfile belongs next
to the symlink target — so `~/.config/mise/mise.lock` should not exist.

```sh
cd ~/repos/dotfiles
mise lock --global           # refresh every tool
mise lock --global <tool>    # one tool
```

### Run it from this directory

`mise lock --global` resolves its target from the current directory, contrary to
the docs:

| cwd | writes to |
|---|---|
| `~/repos/dotfiles` | `~/repos/dotfiles/mise.lock` ✅ |
| anywhere else | `~/.config/mise/mise.lock` ❌ |

Running it from `$HOME` creates a **second** lockfile that mise then prefers over
this one. The two drift apart and you get different tool versions depending on
which directory you are standing in — `mise ls --current` reported atuin 18.20.1
from `~` and 18.22.0 from the repo, off the same config file. If that file ever
reappears, delete it; the repo copy is the only one that should exist.

(mise 2026.9.12. Worth an upstream issue — the docs describe the dotfiles-symlink
case as supported and say cwd should not matter.)

### Platforms

`[settings] lockfile_platforms = ["macos-arm64"]` in `mise.toml` scopes resolution,
so no `--platform` flag is needed. Without it `mise lock` resolves every platform it
knows about and sweeps hundreds of linux/musl/windows/x64 entries into the lockfile
of an Apple-Silicon-only config.

The setting only governs what mise resolves *next* — it does not prune what is
already there. `mise lock --global --upgrade` (lockfile format v2) does that; it
took this file from 4534 lines to 1615. Some foreign-platform entries still remain,
and the file is still `lockfile_version = 1`, because the upgrade stops at
`Python dependency locks require uv >= 0.12.10`. Finish it after a `mise up uv`.

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
bootstrap-sudo.sh    root-owned OS settings mise cannot write
phase5-teardown.sh   removes nix from mbp16; run after darwin-uninstaller
```

## nix machines

```sh
darwin-rebuild switch --flake .#macbook-pro-14
```
