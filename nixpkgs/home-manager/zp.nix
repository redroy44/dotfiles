{ config, lib, pkgs, ... }:

{
  imports = [
    # ./modules/home-manager.nix
    ./modules/zsh.nix
    # ./modules/git.nix
    ./modules/starship.nix
    # ./modules/kitty.nix
    # ./modules/neovim.nix # doesn't support lua config
  ];

  home.stateVersion = "22.11";

  fonts.fontconfig.enable = true;

  home.username = "zp";
  home.homeDirectory = "/Users/zp";

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

    # Ruby
    ruby
    rubocop
    rbenv

    nodejs
    nodePackages.npm

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
