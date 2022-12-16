{ config, pkgs, pkgsUnstable, libs, ... }:
{

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs; [
    gnupg
    tmux
    wget
    bat
    htop
    fzf
    neofetch # fancy system + hardware info
    lsd
    tree
    ripgrep
    silver-searcher
    graphviz

    google-cloud-sdk
    neovim
    heroku
    k9s
    awscli
    vault
    jq
    pre-commit

    fira-code
    fira-code-symbols
    jetbrains-mono
    nerdfonts

  ] ++ lib.optionals stdenv.isDarwin [
    coreutils # provides `dd` with --status=progress
    # wifi-password
  ] ++ lib.optionals stdenv.isLinux [
    # iputils # provides `ping`, `ifconfig`, ...

    # libuuid # `uuidgen` (already pre-installed on mac)
  ];


}