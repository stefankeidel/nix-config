{
  config,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}: {
  home-manager.users.${userConfig.name}.home.packages = with pkgs; [
    pkgs.zoom-us
    pkgs.discord
  ];
}
