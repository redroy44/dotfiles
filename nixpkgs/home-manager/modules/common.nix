{ config, pkgs, pkgsUnstable, libs, ... }:
{

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
