{
  config,
  pkgs,
  lib,
  home-manager,
  userConfig,
  ...
}: {
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
}
