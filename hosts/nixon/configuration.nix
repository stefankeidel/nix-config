{ config, inputs, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "nixon";
  networking.domain = "";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.stefan = {
    isNormalUser = true;
    extraGroups = ["wheel"];

    openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwU52M/vXuUkthu481OGKYMzFGwc9GfjvVwDLt7yQGeDXUZHx5tpL2NEKSS3imnTfOJp25wFTOAJdF63eznIOUEc+5dCZe8xeZ7IMASGlNQJy51sNUlx986BIjYxLbCl0tykkySs82ZNaog9BapjxiHm2tXb1LFR2CsGOg9mLqRVNxQkOj8KkX5+r/NhVxQRFFW8OJn7rgqsyJtA7vKRwEP+nUsokO3cr/+sWeW7APgrnnkh9iYr/ZG6ibZH/m1+t4yW1kcENVy2X8Gyrs0GWMYQCLrBB+zJYBdwxBdeWSt76QlZnOpdwWcaZEC5PUVzTiKtyUok2NjBoqdpnLezrDw=='' ];
  };

  # it's just me :shrug:
  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.openssh = {
    enable = true;
    ports = [22];
    # only on tailscale
    openFirewall = false;

    settings = {
      PasswordAuthentication = false;
      AllowUsers = ["stefan"];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  # Tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "server";
  services.tailscale.extraSetFlags = ["--advertise-exit-node"];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    41641 # tailscale
  ];

  environment.systemPackages = with pkgs; [
    fuse
    git
    htop
    mosh
    rclone
    restic
    ripgrep
    rsync
    screen
    speedtest-go
    tailscale
    vim
    vnstat
    wget
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default
  ];
  
  system.stateVersion = "23.11";
}
