{ config, pkgs, lib, libs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # completionInit = "autoload -U compinit && compinit -u";

    envExtra = (builtins.concatStringsSep "\n" [
      "KUBECONFIG=\"$HOME/.kube/config\""
      "PATH=\"$HOME/.npm-global/bin:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/bin:$PATH:/Users/pbandurski/Library/Application Support/Coursier/bin\""
      "ZSH_DISABLE_COMPFIX=\"true\""
      "eval \"$(direnv hook zsh)\""
      "eval \"$(wt config shell init zsh)\""
      "eval \"$(mise activate zsh)\""
    ]);

    oh-my-zsh = {
      enable = true;
      theme = "lambda";
      plugins = [
        # "ssh-agent"
        "aws"
        "kitty"
        "git"
        "sbt"
        "python"
        "tmux"
        "docker"
        "fzf"
        "direnv"
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
      a = "source start_aws";
    };
  };
}
