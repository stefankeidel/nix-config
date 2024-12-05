{
  description = "Stefans Laptop config";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # last known working version of bwcli
    # https://github.com/NixOS/nixpkgs/commit/cfa3e57cd9accf657ed8933295fc8717ad3d2476
    nixpkgs-bwcli.url = "github:NixOS/nixpkgs/cfa3e57cd9accf657ed8933295fc8717ad3d2476";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
      nix-darwin,
      nixpkgs,
      nixpkgs-bwcli,
      home-manager
  }: {
    darwinConfigurations = {
      "Stefan-Keidel-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          pkgs-bwcli = import nixpkgs-bwcli {
            system = "aarch64-darwin";
          };
        };

        modules = [
          {
            _module.args = {
              userConfig = {
                name = "stefan.keidel@lichtblick.de";
                home = "/Users/stefan.keidel@lichtblick.de/";
              };
            };
          }
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;

            home-manager.users."stefan.keidel@lichtblick.de" = import ./home.nix;
          }
        ];
      };
      "roger.local" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";

        specialArgs = {
          pkgs-bwcli = import nixpkgs-bwcli {
            system = "x86_64-darwin";
          };
        };

        modules = [
          {
            _module.args = {
              userConfig = {
                name = "stefan";
                home = "/Users/stefan/";
              };
            };
          }
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;

            home-manager.users."stefan" = import ./home.nix;
          }
        ];
      };
    };
  };
}
