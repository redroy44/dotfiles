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

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    fira-code
    fira-code-symbols
   ];

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


homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
      cleanup = "none";
    };

    global = {
      autoUpdate = true;
      brewfile = true;
      # lockfiles = true;
    };

    taps = [
      "dhth/tap"
    ];

    brews = [
      # "bitwarden-cli"
      # "cueitup"
    ];

    casks = [
      # Fonts
      "font-fira-code"
      "font-fira-code-nerd-font"

      # Dev
      # "docker"
      "iterm2"
      "postman"
      "rectangle"

      "ghostty"
      # "gleam"

      "copilot-cli"

      "raycast"
      "postico"
      "visual-studio-code"
      "intellij-idea-ce"
      "slack"
      "brave-browser"
      "arc"
      "obsidian"
      "itsycal"
      "zoom"
      "bitwarden"

      # Productivity
      "spark-app"

      # Media
      "spotify"
    ];

    masApps = {
      "EasyRes" = 688211836;
      "Battery Monitor: Health, Info" = 836505650;
    };
  };

}
