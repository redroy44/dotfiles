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
     "#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!"
     "export SDKMAN_DIR=\"/Users/pbandurski/.sdkman\""
     "[[ -s \"/Users/pbandurski/.sdkman/bin/sdkman-init.sh\" ]] && source \"/Users/pbandurski/.sdkman/bin/sdkman-init.sh\""
     "eval \"$(starship init zsh)\""
    ]);
    
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