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

        # terraform is unfree :-/
        nixpkgs.config.allowUnfree = true;

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # trackpad stuff
        system.defaults.trackpad.TrackpadRightClick = true;
        system.defaults.trackpad.Clicking = false;
        system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
        system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        system.defaults.NSGlobalDomain."com.apple.trackpad.forceClick" = true;

        # key repeat
        system.defaults.NSGlobalDomain.KeyRepeat = 2;

        # dock position right
        system.defaults.dock.orientation = "left";

        # various auto subs
        system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
        system.defaults.NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
        system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
        system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
        system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
        system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

        system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

        system.defaults.NSGlobalDomain.AppleFontSmoothing = 2;
        system.defaults.finder.AppleShowAllExtensions = true;
        system.defaults.finder.ShowStatusBar = true;
        system.defaults.finder.ShowPathbar = true;

        system.defaults.finder.QuitMenuItem = true;
        system.defaults.finder._FXShowPosixPathInTitle = true;
        system.defaults.finder._FXSortFoldersFirst = true;
        system.defaults.finder.FXDefaultSearchScope = "SCcf";
        system.defaults.finder.FXEnableExtensionChangeWarning = false;

        system.defaults.finder.FXPreferredViewStyle = "Nlsv";

        system.defaults.dock.minimize-to-application = true;
        system.defaults.dock.show-recents = false;

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
          pkgs.emacs29
        ];

        fonts.packages = with pkgs; [
          pkgs.nerdfonts
        ];

        homebrew = {
          enable = true;

          onActivation.cleanup = "uninstall";

          taps = [];
          brews = [
            "bitwarden-cli"
          ];
          casks = [
            "firefox"
            "docker"
          ];
        };
    };

    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration 
      # for home-manager, don't change this!
      home.stateVersion = "23.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        pkgs.azure-cli
        pkgs.coreutils
        pkgs.k9s
        pkgs.kubectl
        pkgs.nodejs
        pkgs.pyright
        pkgs.ripgrep
        pkgs.signal-desktop
        pkgs.spaceship-prompt
        pkgs.terraform
        pkgs.terraform-ls
        pkgs.vim
        pkgs.wezterm
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        # bit hacky way to source the theme but it works :shrug:
        initExtra = ''
          source ${pkgs.spaceship-prompt}/share/zsh/themes/spaceship.zsh-theme;
          eval "$(/opt/homebrew/bin/brew shellenv)"

          source ~/.functions
          source ~/.extra
        '';

        shellAliases = {
          ll = "ls -l";
          update-nix = "nix run nix-darwin -- switch --flake ~/code/nix-config";
          pythonShell = "nix develop ~/code/nix-config/utils/python-dev#python311 -c $SHELL";
        };

        history = {
          size = 1000000;
        };

        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "z" "terraform" "poetry"];
        };
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      home.sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        MANPAGER = "less -X";
        PYTHONBREAKPOINT = "pudb.set_trace";
        BAT_THEME = "TwoDark";

        # correct grey for zsh autocomplete
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=243";

        # no async fetching of azure sub on every prompt
        SPACESHIP_AZURE_SHOW = "false";
        SPACESHIP_PROMPT_ASYNC = "false"; # irritating af
        SPACESHIP_DOCKER_SHOW = "false"; # what good does the version do

        # Always-true work stuff
        AIRFLOW_UID = 502;
        AIRFLOW_GID = 0;
        AIRFLOW_PLATFORM = "linux/arm64";
      };

      home.file.".vimrc".source = ./dotfiles/vim_config;
      home.file.".wezterm.lua".source = ./dotfiles/weztermconfig.lua;
      home.file.".functions".source = ./dotfiles/functions;
      home.file.".hushlogin".source = ./dotfiles/hushlogin;
      home.file.".gitconfig".source = ./dotfiles/gitconfig;
      home.file.".tmux.conf".source = ./dotfiles/tmux.conf;
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
