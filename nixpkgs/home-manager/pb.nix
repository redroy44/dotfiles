{ config, lib, pkgs, pkgsUnstable, ... }:

{
  imports = [
    # ./modules/home-manager.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/kitty.nix
    # ./modules/neovim.nix # doesn't support lua config
  ];

  home.stateVersion = "23.05";

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
    gdu

    heroku
    k9s
    kubectl
    awscli2
    terraform
    terraform-ls
    vault
    jq
    pre-commit
    lazygit

    nerdfonts

    # Scala
    jdk17
    coursier
    # ammonite
    # bloop # not supported on aarch64-darwin
    sbt
    scala
    scalafmt
    scala-cli

    python310
    python310Packages.ec2instanceconnectcli
    python310Packages.pip
    poetry
    nodejs
    nodePackages.npm

    # colima
    docker
    # docker-compose
    
  ] ++ lib.optionals stdenv.isDarwin [
    coreutils # provides `dd` with --status=progress
    # wifi-password
  ] ++ lib.optionals stdenv.isLinux [
    # iputils # provides `ping`, `ifconfig`, ...

    # libuuid # `uuidgen` (already pre-installed on mac)
  ] ++ [
    pkgsUnstable.neovim
  ];

}
