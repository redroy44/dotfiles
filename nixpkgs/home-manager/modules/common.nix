{ config, pkgs, pkgsUnstable, libs, ... }:
{

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  programs.delta = {
      enable = true;
      enableGitIntegration = true
      options = {
        side-by-side = true;
      };
    };

  home.packages = with pkgs; [
    gnupg
    tmux
    wget
    bat
    htop
    bottom
    fzf
    fd
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
    kubernetes-helm
    awscli
    vault
    jq
    pre-commit
    difftastic

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
