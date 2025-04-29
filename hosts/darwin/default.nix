{
  self,
  inputs,
  config,
  pkgs,
  lib,
  userConfig,
  ...
}: {
  imports = [
    ../../modules/home-manager.nix
    #    ../../modules/shared
  ];

  # secrets
  age.secrets = {
    rclone = {
      file = ../../secrets/rclone.conf.age;
      path = userConfig.home + "/.config/rclone/rclone.conf";
      owner = userConfig.name;
      group = "staff";
      mode = "600";
    };
    restic = {
      file = ../../secrets/restic.age;
      path = userConfig.home + "/.config/restic-pw";
      owner = userConfig.name;
      group = "staff";
      mode = "600";
    };
    discord = {
      file = ../../secrets/discord_bot_token.age;
      path = userConfig.home + "/.config/discord_token";
      owner = userConfig.name;
      group = "staff";
      mode = "600";
    };
    pgpass = {
      file = ../../secrets/pgpass.age;
      path = userConfig.home + "/.pgpass";
      owner = userConfig.name;
      group = "staff";
      mode = "600";
    };
    authinfo = {
      file = ../../secrets/authinfo.age;
      path = userConfig.home + "/.authinfo";
      owner = userConfig.name;
      group = "staff";
      mode = "600";
    };
  };

  # packages to install on Darwin desktop systems
  # headless (default) packages get pulled in by the home manager module
  home-manager.users.${userConfig.name}.home.packages = lib.mkMerge [
    (pkgs.callPackage ../../modules/dev-packages.nix {inherit inputs;})
    (pkgs.callPackage ../../modules/gui-packages.nix {inherit inputs;})
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # terraform is unfree :-/
  nixpkgs.config.allowUnfree = true;

  #system.configurationRevision = self.rev or self.dirtyRev or null;
  # cachix
  nix.settings.extra-substituters = "https://cache.nixos.org https://nix-community.cachix.org https://sylvorg.cachix.org";
  nix.settings.extra-trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= sylvorg.cachix.org-1:xd1jb7cDkzX+D+Wqt6TemzkJH9u9esXEFu1yaR9p8H8=";

  # trackpad stuff
  system.defaults.trackpad.TrackpadRightClick = true;
  system.defaults.trackpad.Clicking = false;
  system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
  system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
  system.defaults.NSGlobalDomain."com.apple.trackpad.forceClick" = true;

  # mouse accelleration
  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;

  # key repeat
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

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
  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  # If you're on an Intel system, replace with "x86_64-darwin"
  #nixpkgs.hostPlatform = "aarch64-darwin";

  # Declare the user that will be running `nix-darwin`.
  users.users."${userConfig.name}" = {
    name = "${userConfig.name}";
    home = "${userConfig.home}";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    (emacs.override { withNativeCompilation = false; })
    #emacs
    inputs.agenix.packages.${system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # launchd = {
  #   user = {
  #     agents = {
  #       ollama-serve = {
  #         command = "${pkgs.ollama}/bin/ollama serve";
  #         serviceConfig = {
  #           KeepAlive = true;
  #           RunAtLoad = true;
  #           StandardOutPath = "/tmp/ollama_stefan.out.log";
  #           StandardErrorPath = "/tmp/ollama_stefan.err.log";
  #         };
  #       };
  #     };
  #   };
  # };
}
