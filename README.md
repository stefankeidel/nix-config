# Bootstrapping

Need to write this down in more detail but essentially when setting up a new machine

- run `git` to install XCode CLI tools
- run determinate systems nix installer: https://github.com/DeterminateSystems/nix-installer
- clone this repo somewhere, e.g. `~code/nix-config`
- `nix run nix-darwin -- switch --flake ~/code/nix-config`

Done :)
