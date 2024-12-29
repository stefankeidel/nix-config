{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  pkgs.appcleaner
  pkgs.dockutil
  pkgs.jetbrains.datagrip
  pkgs.raycast
  pkgs.signal-desktop
  pkgs.spotify
  pkgs.wezterm
  pkgs.zoom-us
]
