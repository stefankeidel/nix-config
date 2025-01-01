{
  config,
  inputs,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}: {
  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    pkgs.azure-cli
    pkgs.kubelogin
    (writeShellScriptBin "do_bak" ''
      #!/usr/bin/env zsh
      set -e
      restic --repo rclone:sb:lichtblick-bak backup ~/code ~/Documents ~/Desktop ~/Nextcloud --skip-if-unchanged
      restic --repo rclone:sb:lichtblick-bak forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 1 --prune
    '')
  ];
}
