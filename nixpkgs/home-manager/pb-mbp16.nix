{ config, lib, pkgs, pkgsUnstable, ghostty, mcphub-nvim, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/starship.nix
    ./modules/kitty.nix
    ./modules/yazi.nix
    # ./modules/ghostty.nix
    # ./modules/neovim.nix # doesn't support lua config
  ];

  home.stateVersion = "25.11";

  #fonts.fontconfig.enable = true;

  fonts.fontconfig.enable = false;

  home.username = "pbandurski";
  home.homeDirectory = "/Users/pbandurski";

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      side-by-side = true;
    };
  };

  home.packages = with pkgs; [
    gnupg
    tmux
    wget
    bat
    htop
    bottom
    fzf
    neofetch # fancy system + hardware info
    lsd
    tree
    ripgrep
    silver-searcher
    graphviz
    iterm2
    httpie
    gdu
    difftastic
    fd

    just
    awsume
    aws-sso-util
    google-cloud-sdk
    # neovim
    heroku
    k9s
    kubectl
    kubernetes-helm
    tenv
    terraform-ls

    tflint
    vault
    jq
    yq
    pre-commit
    lazygit
    gh
    kcat

    # nerdfonts

    # Scala
    jdk21
    coursier
    # ammonite
    # bloop # not supported on aarch64-darwin
    sbt
    scala
    scalafmt
    # scala-cli # install using coursier

    python314
    # python315
    # python314Packages.ec2instanceconnectcli
    # python314Packages.pip
    # python314Packages.virtualenv
    poetry

    nodejs_20
    bun
    #nodePackages.npm
    #yarn

    # Rust
    rustup
    # rustc
    # cargo

    # colima
    docker
    docker-compose
    lazydocker
    act

    nix-search-cli

  ] ++ lib.optionals stdenv.isDarwin [
    coreutils # provides `dd` with --status=progress
    # wifi-password
  ] ++ lib.optionals stdenv.isLinux [
    # iputils # provides `ping`, `ifconfig`, ...

    # libuuid # `uuidgen` (already pre-installed on mac)
  ] ++ [
    # pkgsUnstable.gleam
    pkgsUnstable.vectorcode
    pkgsUnstable.neovim 
    pkgsUnstable.awscli2
    # pkgsUnstable.uv
  ];

}
