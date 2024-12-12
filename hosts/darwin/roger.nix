{
  config,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}: {
  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    pkgs.plex-media-player
  ];
}
