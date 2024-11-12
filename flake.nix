# ~/.config/nix/flake.nix

{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = {pkgs, ... }: {

        services.nix-daemon.enable = true;
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # trackpad stuff
        system.defaults.trackpad.TrackpadRightClick = true;
        system.defaults.trackpad.Clicking = false;
        system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
        system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        system.defaults.NSGlobalDomain."com.apple.trackpad.forceClick" = true;

        # key repeat
        system.defaults.NSGlobalDomain.KeyRepeat = 2;

        # stop asking for sudo perms
        security.pam.enableSudoTouchIdAuth = true;

        # Used for backwards compatibility. please read the changelog
        # before changing: `darwin-rebuild changelog`.
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        # If you're on an Intel system, replace with "x86_64-darwin"
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Declare the user that will be running `nix-darwin`.
        users.users."stefan.keidel@lichtblick.de" = {
            name = "stefan.keidel@lichtblick.de";
            home = "/Users/stefan.keidel@lichtblick.de";
        };

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        environment.systemPackages = [
          pkgs.neofetch
          pkgs.vim
          pkgs.nodejs
          pkgs.emacs29
          pkgs.coreutils
          pkgs.ripgrep
        ];

        fonts.packages = with pkgs; [
          pkgs.nerdfonts
        ];

        homebrew = {
          enable = true;
          # onActivation.cleanup = "uninstall";

          taps = [];
          brews = [];
          casks = [];
        };
    };

    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration 
      # for home-manager, don't change this!
      home.stateVersion = "23.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = with pkgs; [];

      home.sessionVariables = {
        EDITOR = "vim";
      };

      programs.wezterm = {
        enable = true;
        enableZshIntegration = true;
        extraConfig = builtins.readFile ./dotfiles/weztermconfig.lua;
      };

      home.file.".vimrc".source = ./dotfiles/vim_config;
    };

  in
  {
    darwinConfigurations."Stefan-Keidel-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager  {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users."stefan.keidel@lichtblick.de" = homeconfig;
        }
      ];
    };
  };
}
