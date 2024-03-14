{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Piotr Bandurski";
    userEmail = "redroy44@gmail.com";

    includes = [
      { 
        path = "~/code/.gitconfig";
        condition = "gitdir:~/code/";
      }
    ];

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

    ignores = [
      "**/.metals/"
      "**/project/metals.sbt"
      "**/.idea/"
      "**/.vscode/settings.json"
      "**/.bloop/"
      "**/.bsp/"
      "**/.scala-build/"
      "**/.direnv/"
      "**/.DS_Store"
      ".direnv"
      ".envrc"
      ".env"
    ];

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