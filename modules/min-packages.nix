{pkgs, inputs, ...}:
with pkgs; [
  pkgs.coreutils
  pkgs.curl
  pkgs.docker-buildx
  pkgs.docker-client
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
  pkgs.speedtest-cli
  pkgs.tree-sitter
  pkgs.vim
  pkgs.wget
]