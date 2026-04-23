{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    settings.user.name = "Piotr Bandurski";
    settings.user.email = "redroy44@gmail.com";

    includes = [
      { 
        path = "~/code/.gitconfig";
        condition = "gitdir:~/code/";
      }
    ];



    signing = {
      key = "07A01229AAA846E1";
    };

    ignores = [
      "**/.metals/"
      "**/project/metals.sbt"
      "**/.idea/"
      "**/.vscode/settings.json"
      "**/.cursor/"
      "**/.bloop/"
      "**/.bsp/"
      "**/.scala-build/"
      "**/.direnv/"
      "**/.DS_Store"
      ".direnv"
      ".envrc"
      ".env"
      "**/.claude/"
      "CLAUDE.md"
    ];

    settings.alias = {
      # `git log` with patches shown with difftastic.
      dl = "-c diff.external=difft log -p --ext-diff";

      # Show the most recent commit with difftastic.
      ds = "-c diff.external=difft show --ext-diff";

      # `git diff` with difftastic.
      dft = "-c diff.external=difft diff";
    };

    settings = {
      pull.rebase = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;

      core.editor = "nvim";
      core.fileMode = false;
      core.ignorecase = false;

      merge.conflictstyle = "zdiff3";

      rerere.enabled = true;
    };
  };
  
}
