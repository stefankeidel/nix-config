{
  description = "Stefans Laptop config";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # last known working version of bwcli
    # https://github.com/NixOS/nixpkgs/commit/cfa3e57cd9accf657ed8933295fc8717ad3d2476
    bwcli.url = "github:NixOS/nixpkgs/cfa3e57cd9accf657ed8933295fc8717ad3d2476";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stefan-website = {
      type = "github";
      owner = "stefankeidel";
      repo = "website";
      flake = false;
    };
  };

  outputs = inputs @ {
      self,
      nixpkgs,
      bwcli,
      nix-darwin,
      nix-stable,
      home-manager,
      ...
  }: {
    nixosConfigurations.nixie = nix-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./hetzner/configuration.nix
      ];
    };
    # Mac Laptop crap
    darwinConfigurations = {
      # work laptop
      "Stefan-Keidel-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          inherit inputs;

          userConfig = {
            name = "stefan.keidel@lichtblick.de";
            home = "/Users/stefan.keidel@lichtblick.de/";
          };
        };

        modules = [
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
      # old laptop, barely used anymore. build might might be broken
      "roger" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";

        specialArgs = {
          inherit inputs;

          userConfig = {
            name = "stefan";
            home = "/Users/stefan/";
          };
        };

        modules = [
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
