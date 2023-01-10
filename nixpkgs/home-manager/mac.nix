{ config, lib, pkgs, ... }:

{
  imports = [
    # ./modules/home-manager.nix
    ./modules/zsh.nix
    ./modules/common.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/kitty.nix
    # ./modules/neovim.nix # doesn't support lua config
  ];

  home.stateVersion = "22.11";

  fonts.fontconfig.enable = true;

}
