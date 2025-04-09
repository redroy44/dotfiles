{ config, pkgs, lib, libs, ... }:
{
  programs.ghostty = {
    enable = true;
   # package = "pkgs.ghostty";
    enableZshIntegration = true;
  #  installVimSyntax = false;
    settings = {
  #    font-family = "FiraCode Nerd Font Mono";
      font-size = 16;
    };
  };
}
