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
  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    pkgs.discord
    pkgs.ffmpeg
    pkgs.ghostscript
    pkgs.postgresql
    pkgs.yt-dlp
    pkgs.zoom-us
    (writeShellScriptBin "do_bak" ''
      #!/usr/bin/env zsh
      set -e
      restic --password-file ~/.config/restic-pw --repo rclone:sb:mini-bak backup ~/code ~/Documents ~/Desktop ~/Nextcloud /Volumes/SAMSUNG/Photos\ Library.photoslibrary/ --skip-if-unchanged
      restic --password-file ~/.config/restic-pw --repo rclone:sb:mini-bak forget --keep-daily 7 --keep-weekly 2 --keep-monthly 3 --prune
    '')
  ];
}
