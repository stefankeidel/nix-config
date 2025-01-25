{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  pkgs.alejandra
  pkgs.colima
  pkgs.docker-buildx
  pkgs.docker-client
  pkgs.k9s
  pkgs.kalker
  pkgs.kubectl
  pkgs.kubectx
  pkgs.kubernetes-helm
  pkgs.morph
  pkgs.mosh
  pkgs.nodejs
  pkgs.pwgen
  pkgs.pyright
  pkgs.python312
  pkgs.terraform
  pkgs.terraform-ls
  inputs.bwcli.legacyPackages."${pkgs.system}".bitwarden-cli
]
