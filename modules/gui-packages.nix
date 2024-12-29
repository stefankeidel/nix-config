{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  pkgs.jetbrains.datagrip
  pkgs.raycast
  pkgs.signal-desktop
  pkgs.spotify
  pkgs.wezterm
  pkgs.dockutil
  pkgs.zoom-us
]
