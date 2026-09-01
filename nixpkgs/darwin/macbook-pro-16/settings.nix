{ pkgs, ... }:
{
  # NSGlobalDomain / dock / finder moved to [bootstrap.macos.defaults] in mise.toml
  # (phase 4). What is left below is only what mise cannot write: sudo-domain
  # settings. These disappear with nix-darwin in phase 5 and must then be re-set
  # by hand — see "Not migratable" in HANDOFF.md.
  system.defaults = {
    loginwindow.GuestEnabled = false;

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  system.primaryUser = "pbandurski";

  networking.applicationFirewall.enable = true;
  networking.applicationFirewall.blockAllIncoming = true;

  # TouchID sudo. STAYS HERE until phase 5 — verified, do not "migrate" it early.
  # Dropping this option does NOT hand /etc/pam.d/sudo_local over to mise: nix-darwin
  # keeps owning the path and just points the symlink at an EMPTY file, so TouchID
  # breaks while mise still refuses to write there (symlink vs file type mismatch).
  # The mise [bootstrap.files] entry can only take over after darwin-uninstaller.
  security.pam.services.sudo_local.touchIdAuth = true;
}
