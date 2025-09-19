{ config, lib, pkgs, ... }:

{
  systemd.services.rclone-hetzner-sb = {
    # Ensure the service starts after the network is up
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /var/lib/navidrome/music"; # Creates folder if didn't exist
      ExecStart = "${pkgs.rclone}/bin/rclone --config /var/lib/navidrome/.config/rclone/rclone.conf mount sb:music /var/lib/navidrome/music --read-only --allow-other"; # Mounts
      ExecStop = "/run/current-system/sw/bin/fusermount -u /var/lib/navidrome/music"; # Dismounts
      Restart = "on-failure";
      RestartSec = "10s";
      User = "navidrome";
      Group = "navidrome";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ]; # Required environments
    };
  };
}
