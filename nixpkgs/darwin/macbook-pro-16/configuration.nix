{ pkgs, ... }:
{
  imports = [
    ./settings.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.problems.handlers.dlinfo.broken = "warn";

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;

  users.users.pbandurski = {
    name = "pbandurski";
    home = "/Users/pbandurski";
  };

  # fonts moved to brew-cask:font-fira-code{,-nerd-font} in mise.toml (phase 4).
  # NOTE: this also drops fira-code-symbols, which has no cask and is not replaced
  # anywhere — see "Known gaps" in HANDOFF.md. Deliberate.

  nix = {
    enable = true;
    package = pkgs.nix;

    optimise.automatic = true;

    extraOptions = ''
      # needed for nix-direnv
      keep-outputs = true
      keep-derivations = true
      # assuming the builder has a faster internet connection
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';

    # buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
    #   {
    #     systems = [ "aarch64-linux" "x86_64-linux" ];
    #     sshUser = "root";
    #     maxJobs = 4;
    #     # relies on `/var/root/.ssh/nix-builder` key to be there
    #     # TODO set this up via nix
    #     hostName = "oracle-nix-builder";
    #     supportedFeatures = [ "nixos-test" "benchmark" "kvm" "big-parallel" ];
    #   }
    # ];
    # distributedBuilds = config.nix.buildMachines != [ ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;


# taps / brews / casks / masApps moved to [bootstrap.packages] in mise.toml (phase 4).
# Removing this block does not uninstall anything: onActivation.cleanup was "none",
# so nix-darwin never owned the artifacts, only the Brewfile it generated.

}
