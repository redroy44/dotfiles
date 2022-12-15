{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    extraConfig =  (builtins.readFile ./init.lua);
    # xdg.configFile."nvim/init.lua".text = builtins.readFiles /path/to/localfs/nvim/init.lua;
  };
}