# Bootstrapping

My rig to set up a new MacOS install from scratch using Nix

Steps are roughly:

- Get as clean a system as you can, ideally fresh Mac OS install
- run `git` in Terminal to install XCode CLI tools (it will prompt you)
- run determinate systems nix installer: https://github.com/DeterminateSystems/nix-installer
- clone this repo somewhere, e.g. `~/code/nix-config`
- `nix run nix-darwin -- switch --flake ~/code/nix-config`

That will take a while but should actually be it.
