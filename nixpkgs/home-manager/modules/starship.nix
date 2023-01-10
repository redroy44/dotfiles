{ config, pkgs, lib, libs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {

    };
  };
}
