{ config, pkgs, lib, libs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
    };
  };
}