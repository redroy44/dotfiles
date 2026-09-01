{ config, pkgs, libs, ... }:
{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs = {
    # You can add overlays here
    # overlays = [
    # ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
}