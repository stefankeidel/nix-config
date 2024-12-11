{ self, inputs, pkgs, userConfig, ... }:

{
  services.nix-daemon.enable = true;
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # terraform is unfree :-/
  nixpkgs.config.allowUnfree = true;

  #system.configurationRevision = self.rev or self.dirtyRev or null;

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
  #nixpkgs.hostPlatform = "aarch64-darwin";

  # Declare the user that will be running `nix-darwin`.
  users.users."${userConfig.name}" = {
      name = "${userConfig.name}";
      home = "${userConfig.home}";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    emacs29
    inputs.bwcli.legacyPackages."${pkgs.system}".bitwarden-cli
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];
}
