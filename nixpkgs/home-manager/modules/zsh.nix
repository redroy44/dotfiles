{ config, pkgs, lib, libs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    initExtraFirst = (builtins.concatStringsSep "\n" [
      "export KUBECONFIG=\"$HOME/.kube/config\""
    ]);

    initExtra = (builtins.concatStringsSep "\n" [
     "eval \"$(starship init zsh)\""
    ]);
    
    # initExtraBeforeCompInit = (builtins.concatStringsSep "\n" [
    #  "fpath=(~/.zsh/completion $fpath)"
    # ]);

    oh-my-zsh = {
      enable = true;
      theme = "lambda";
      plugins = [
        "git"
        "sbt"
        "python"
        "tmux"
        "docker"
        "fzf"
      ];
    };

    shellAliases = {
      vim = "nvim";
      ls = "lsd";
      l = "ls -l";
      la = "ls -a"; 
      lla = "ls -la";
      lt = "ls --tree --depth 5";
    };

  };
}