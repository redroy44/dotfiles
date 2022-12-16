{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Piotr Bandurski";
    userEmail = "piotr.bandurski@scalac.io";

    delta = {
      enable = true;
      options = {
        syntax-theme = "solarized-dark";
        side-by-side = true;
      };
    };

    signing = {
      key = "07A01229AAA846E1";
    };

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;

      core.editor = "nvim";
      core.fileMode = false;
      core.ignorecase = false;
    };
  };
}