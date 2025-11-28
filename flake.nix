{
  description = "Stefans Laptop config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # for pinning poetry to 1.6.1
    # https://github.com/NixOS/nixpkgs/commit/881e946d8b96b1c52d74e2b69792aa89354feffd
    # poetrypin.url = "github:NixOS/nixpkgs/881e946d8b96b1c52d74e2b69792aa89354feffd";

    # for pinning kubelogin
    # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable/pkgs/by-name/ku/kubelogin/package.nix
    kubeloginpin.url = "github:NixOS/nixpkgs/0fe617b0b02eb2f8480feb0dd577953867c9edec";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    # deploy-rs for remote NixOS deployments
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    nix-stable,
    home-manager,
    agenix,
    kubeloginpin,
    deploy-rs,
    nix-rosetta-builder,
    ...
  }: {
    nixosConfigurations.nixie = nix-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        agenix.nixosModules.default
        ./hosts/nixie/configuration.nix
      ];
    };
    nixosConfigurations.derp = nix-stable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        agenix.nixosModules.default
        ./hosts/nixie/configuration.nix
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
            home = "/Users/stefan.keidel@lichtblick.de";
          };
        };

        modules = [
          ./hosts/darwin/default.nix
          agenix.nixosModules.default
          home-manager.darwinModules.home-manager
          # custom settings for this machine
          ./hosts/darwin/lichtblick.nix
          # An existing Linux builder is needed to initially bootstrap `nix-rosetta-builder`.
          # If one isn't already available: comment out the `nix-rosetta-builder` module below,
          # uncomment this `linux-builder` module, and run `darwin-rebuild switch`:
          #{ nix.linux-builder.enable = true;}
          # Then: uncomment `nix-rosetta-builder`, remove `linux-builder`, and `darwin-rebuild switch`
          # a second time. Subsequently, `nix-rosetta-builder` can rebuild itself.
          # nix-rosetta-builder.darwinModules.default
          # {
          #   # see available options in module.nix's `options.nix-rosetta-builder`
          #   nix-rosetta-builder.onDemand = true;
          # }
        ];
      };
      # Mac mini at home
      "mini" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          inherit inputs;

          userConfig = {
            name = "stefan";
            home = "/Users/stefan";
          };
        };

        modules = [
          ./hosts/darwin/default.nix
          agenix.nixosModules.default
          home-manager.darwinModules.home-manager
          # custom settings for this machine
          ./hosts/darwin/mini.nix
        ];
      };
    };
    # devShells.aarch64-darwin = builtins.mapAttrs makePythonShell pythonVersions;

    # deploy-rs configuration for deploying the nixie host
    # dry run: nix run github:serokell/deploy-rs -- --dry-activate .#nixie
    # actual deployment: nix run github:serokell/deploy-rs -- .#nixie
    deploy = {
      nodes.nixie = {
        # Adjust to a reachable SSH host/IP (e.g. tailscale IP or public DNS)
        hostname = "nixie";
        # Build the system derivation on the remote (Linux) host instead of
        # attempting to build x86_64-linux derivations on the local aarch64-darwin machine.
        remoteBuild = true;
        sshUser = "stefan";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixie;
        };
      };
    };
  };
}
