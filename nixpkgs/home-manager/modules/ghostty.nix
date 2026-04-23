{ config, pkgs, lib, libs, ghostty ... }:
{
  programs.ghostty = {
    enable = true;
    package = "ghostty";
    enableZshIntegration = true;
  #  installVimSyntax = false;
    settings = {
  #    font-family = "FiraCode Nerd Font Mono";
      font-size = 16;
    };
  };
}
