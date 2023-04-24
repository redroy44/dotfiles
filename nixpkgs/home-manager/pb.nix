{ config, lib, pkgs, ... }:

{
  imports = [
    # ./modules/home-manager.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/kitty.nix
    # ./modules/neovim.nix # doesn't support lua config
  ];

  home.stateVersion = "22.11";

  fonts.fontconfig.enable = true;

  home.username = "pbandurski";
  home.homeDirectory = "/Users/pbandurski";

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    gnupg
    tmux
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

    google-cloud-sdk
    neovim
    heroku
    k9s
    kubectl
    awscli
    terraform
    terraform-ls
    vault
    jq
    pre-commit

    fira-code
    fira-code-symbols
    jetbrains-mono
    nerdfonts

    # Scala
    jdk17
    coursier
    ammonite
    sbt
    scala
    scalafmt
    scala-cli

    python3
    poetry
    nodejs
    nodePackages.npm

    colima
    docker-client
    docker-compose
    
  ] ++ lib.optionals stdenv.isDarwin [
    coreutils # provides `dd` with --status=progress
    # wifi-password
  ] ++ lib.optionals stdenv.isLinux [
    # iputils # provides `ping`, `ifconfig`, ...

    # libuuid # `uuidgen` (already pre-installed on mac)
  ];

}
