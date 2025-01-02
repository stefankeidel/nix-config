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
  # imports = [
  #   ../../modules/dock
  # ];

  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    pkgs.zoom-us
    pkgs.discord
    pkgs.ffmpeg
    pkgs.ghostscript
    (writeShellScriptBin "do_bak" ''
      #!/usr/bin/env zsh
      set -e
      restic --password-file ~/.config/restic-pw --repo rclone:sb:mini-bak backup ~/code ~/Documents ~/Desktop ~/Nextcloud /Volumes/wd/Photos\ Library.photoslibrary/ --skip-if-unchanged
      restic --password-file ~/.config/restic-pw --repo rclone:sb:mini-bak forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 1 --prune
    '')
  ];

  # Fully declarative dock using the latest from Nix Store
  # local.dock.enable = true;
  # local.dock.entries = [
  #   {path = "${userConfig.home}/Applications/Home Manager Apps/WezTerm.app/";}
  #   {path = "/Applications/Firefox.app/";}
  #   {path = "/System/Applications/Calendar.app/";}
  #   {path = "${pkgs.emacs29}/bin/emacs-29.4";}
  #   {path = "/System/Applications/Mail.app/";}
  #   {path = "${userConfig.home}/Applications/Home Manager Apps/DataGrip.app/";}
  #   {path = "/System/Applications/Notes.app/";}
  #   {path = "${userConfig.home}/Applications/Home Manager Apps/Signal.app/";}
  #   {path = "${userConfig.home}/Applications/Home Manager Apps/Spotify.app/";}
  #   {path = "/Applications/Steam.app";}
  #   {path = "${userConfig.home}/Applications/Home Manager Apps/Discord.app/";}
  #   {path = "/System/Applications/System Settings.app/";}
  #   {path = "/System/Applications/Photos.app/";}
  #   {
  #     path = toString myEmacsLauncher;
  #     section = "others";
  #   }
  # ];
}
