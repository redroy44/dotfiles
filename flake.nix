{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, flake-utils, darwin, nixpkgs, nixpkgsUnstable, home-manager }:

    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {

          devShell = with pkgs; pkgs.mkShell {
            buildInputs = [
              # Just in case :)
            ];
          };

        })
    // # <- concatenates Nix attribute sets
    {

      homeConfigurations = {
        scalac-mbp = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-darwin;
          modules = [ ./nixpkgs/home-manager/mac.nix ];
          # extraModules = [ ./nixpkgs/home-manager/mac.nix ];
          extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-darwin; };
          # system = "aarch64-darwin";
          # configuration = { };
          # homeDirectory = "/home/schickling";
          # username = "schickling";
        };
      };

      darwinConfigurations = {
        # nix build .#darwinConfigurations.MacBook-Pro-Piotr.system
        # ./result/sw/bin/darwin-rebuild switch --flake .
        MacBook-Pro-Piotr = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./nixpkgs/darwin/MacBook-Pro-Piotr/configuration.nix ];
          inputs = { inherit darwin nixpkgs; };
        };
      };
    };
}