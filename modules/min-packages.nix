{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  pkgs.coreutils
  pkgs.curl
  pkgs.dua
  pkgs.eza
  pkgs.git
  pkgs.httpie
  pkgs.netcat-gnu
  pkgs.nix-direnv
  pkgs.nmap
  pkgs.pv
  pkgs.ripgrep
  pkgs.spaceship-prompt
  pkgs.speedtest-go
  pkgs.tree-sitter
  pkgs.unixtools.watch
  pkgs.vim
  pkgs.wget
]
