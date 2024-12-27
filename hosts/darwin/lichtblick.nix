{
  config,
  inputs,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}: let
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/zsh
    emacsclient -c -n 1>/dev/null 2>&1 &
  '';
in {
  imports = [
    ../../modules/dock
  ];

  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    pkgs.azure-cli
    pkgs.kubelogin
  ];

  homebrew = {
    enable = true;

    brews = [
      "cyphernetes"
    ];

    #onActivation.cleanup = "uninstall";
    onActivation.autoUpdate = false;
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    {path = "${userConfig.home}/Applications/Home Manager Apps/WezTerm.app/";}
    {path = "/Applications/Firefox.app/";}
    {path = "/System/Applications/Calendar.app/";}
    {path = "/Applications/Microsoft Outlook.app/";}
    {path = "/Applications/Microsoft Teams.app/";}
    {path = "${inputs.emacsfix.legacyPackages."${pkgs.system}".emacs29}/bin/emacs-29.4";}
    {path = "${userConfig.home}/Applications/Home Manager Apps/Element.app/";}
    {path = "/System/Applications/Mail.app/";}
    {path = "${userConfig.home}/Applications/Home Manager Apps/DataGrip.app/";}
    {path = "/System/Applications/Notes.app/";}
    {path = "${userConfig.home}/Applications/Home Manager Apps/Signal.app/";}
    {path = "${userConfig.home}/Applications/Home Manager Apps/Spotify.app/";}
    {path = "/System/Applications/System Settings.app/";}
    {path = "/System/Applications/Photos.app/";}
    {
      path = toString myEmacsLauncher;
      section = "others";
    }
  ];
}
