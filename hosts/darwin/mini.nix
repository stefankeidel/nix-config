{
  config,
  inputs,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}: {
  ids.gids.nixbld = 350;

  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    # pkgs.discord
    pkgs.ffmpeg
    pkgs.ghostscript
    pkgs.yt-dlp
    pkgs.streamlink
    (writeShellScriptBin "do_bak" ''
      #!/usr/bin/env zsh
      set -e
      restic --password-file ~/.config/restic-pw --repo rclone:sb:mini-bak backup ~/code ~/Documents ~/Desktop ~/Nextcloud /Volumes/West/Photos\ Library.photoslibrary/ --skip-if-unchanged
      restic --password-file ~/.config/restic-pw --repo rclone:sb:mini-bak forget --keep-daily 7 --keep-weekly 2 --keep-monthly 3 --prune
    '')
  ];
}
