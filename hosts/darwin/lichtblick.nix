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

  nix.enable = true;
  # yes, I know what this means
  nix.settings.trusted-users = [ "root" "stefan.keidel@lichtblick.de" ];

  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    # config = ({ ... }: {
    #   virtualisation.darwin-builder.diskSize = 30 * 1024;
    # });
  };

  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    inputs.kubeloginpin.legacyPackages."${pkgs.stdenv.hostPlatform.system}".kubelogin
    pkgs.duckdb
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubernetes-helm
    (writeShellScriptBin "do_bak" ''
      #!/usr/bin/env zsh
      set -e
      restic --password-file ~/.config/restic-pw --repo rclone:sb:lichtblick-bak backup ~/code ~/Documents ~/Desktop ~/Nextcloud --skip-if-unchanged
      restic --password-file ~/.config/restic-pw --repo rclone:sb:lichtblick-bak forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune
    '')
  ];
}
