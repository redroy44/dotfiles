{ config, lib, pkgs, pkgsUnstable, ghostty, mcphub-nvim, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/kitty.nix
    ./modules/yazi.nix
    ./modules/tmux
    # ./modules/ghostty.nix
    # ./modules/neovim.nix # doesn't support lua config
  ];

  home.stateVersion = "25.11";

  fonts.fontconfig.enable = true;


  home.username = "pbandurski";
  home.homeDirectory = "/Users/pbandurski";

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = false;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      side-by-side = true;
    };
  };

  home.packages = with pkgs; [
    # ponytail: direnv's fish test gets SIGKILLed in the sandbox; drop checks. Remove if upstream fixes the test.
    (direnv.overrideAttrs (_: { doCheck = false; }))
    gnupg
    wget
    bat
    htop
    bottom
    fzf
    neofetch # fancy system + hardware info
    lsd
    tree
    ripgrep
    silver-searcher
    graphviz
    iterm2
    httpie
    gdu
    difftastic
    fd

    just
    awsume
    aws-sso-util
    google-cloud-sdk
    # neovim
    heroku
    k9s
    kubectl
    kubernetes-helm
    tenv
    terraform-ls

    nh

    tflint
    vault
    jq
    yq
    pre-commit
    lazygit
    gh
    kcat

    # nerdfonts

    # Scala
    jdk21
    coursier
    # ammonite
    # bloop # not supported on aarch64-darwin
    sbt
    scala
    scalafmt
    # scala-cli # install using coursier

    python314
    # python315
    # python314Packages.ec2instanceconnectcli
    # python314Packages.pip
    # python314Packages.virtualenv
    poetry

    nodejs_24
    bun
    #nodePackages.npm
    #yarn

    # Rust
    rustup
    # rustc
    # cargo

    # colima
    docker_29
    docker-compose
    lazydocker
    act

    nix-search-cli

  ] ++ lib.optionals stdenv.isDarwin [
    coreutils # provides `dd` with --status=progress
    # wifi-password
  ] ++ lib.optionals stdenv.isLinux [
    # iputils # provides `ping`, `ifconfig`, ...

    # libuuid # `uuidgen` (already pre-installed on mac)
  ] ++ [
    # pkgsUnstable.gleam
    # pkgsUnstable.vectorcode
    pkgsUnstable.neovim 
    pkgsUnstable.awscli2
    pkgsUnstable.rtk
    pkgsUnstable.herdr
    pkgsUnstable.worktrunk
    pkgsUnstable.opencode
  ];

}
