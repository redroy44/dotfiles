{ pkgs, ... }:
{
  imports = [
    ./settings.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  users.users.pbandurski = {
    name = "pbandurski";
    home = "/Users/pbandurski";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;

    # Currently disabled `nix.settings.auto-optimise-store` as it seems to fail with remote builders
    # TODO renable when fixed https://github.com/NixOS/nix/issues/7273
    # settings.auto-optimise-store = false;

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


homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
      cleanup = "zap";
    };

    global = {
      autoUpdate = true;
      brewfile = true;
      lockfiles = true;
    };

    taps = [
      "homebrew/core"
      "homebrew/cask"
    ];

    casks = [

      # Dev
      "docker"
      "postman"
      "rectangle"
      # "osxfuse"
      # "avibrazil-rdm"


      "postico"
      "visual-studio-code"
      "intellij-idea-ce"
      "slack"
      "brave-browser"
      "notion"


      # Media
      "spotify"
    ];

    masApps = {
      "NordVPN" = 905953485;
      "Bitwarden" = 1352778147;
      "EasyRes" = 688211836;
      "Spark" = 1176895641;
    };
  };

}
