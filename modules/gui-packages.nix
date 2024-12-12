{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  pkgs.spotify
  pkgs.signal-desktop
  pkgs.wezterm
  pkgs.jetbrains.datagrip
]
