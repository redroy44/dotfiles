{ config, pkgs, lib, libs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    # completionInit = "autoload -U compinit && compinit -u";

    envExtra = (builtins.concatStringsSep "\n" [
      "KUBECONFIG=\"$HOME/.kube/config\""
      "PATH=\"/usr/local/bin:$PATH\""
      "ZSH_DISABLE_COMPFIX=\"true\""
    ]);

    oh-my-zsh = {
      enable = true;
      theme = "lambda";
      plugins = [
        # "ssh-agent"
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
      sbt = "sbt -java-home ~/.nix-profile";
    };

  };
}
