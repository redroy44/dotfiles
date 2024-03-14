{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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
        MacBook-Pro-Piotr = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-darwin;
          modules = [ ./nixpkgs/home-manager/pb.nix ];
          # extraModules = [ ./nixpkgs/home-manager/mac.nix ];
          extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-darwin; };
        };
        macbook-pro-14 = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./nixpkgs/home-manager/pb.nix ];
          # extraModules = [ ./nixpkgs/home-manager/mac.nix ];
          extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin; };
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
        macbook-pro-14 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./nixpkgs/darwin/macbook-pro-14/configuration.nix 
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pbandurski = { 
              imports = [ ./nixpkgs/home-manager/pb-mbp14.nix ]; 
            };
            home-manager.users.zp = { 
              imports = [ ./nixpkgs/home-manager/zp.nix ]; 
            };
            home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin; };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }];
          inputs = { inherit darwin nixpkgs; };
        };
        macbook-pro-16 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./nixpkgs/darwin/macbook-pro-16/configuration.nix 
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.pbandurski = { 
              imports = [ ./nixpkgs/home-manager/pb-mbp16.nix ]; 
            };
            home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin; };
          }];
          inputs = { inherit darwin nixpkgs; };
        };
      };
    };
}
