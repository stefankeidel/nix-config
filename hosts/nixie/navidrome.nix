{ config, pkgs, ... }:

{

  #systemd.services.navidrome.serviceConfig.ProtectHome = "read-only";

  services.navidrome = {
    enable = true;

    # todo: deal with this, but the issue is the reclone mount is owned by me
    # user = "stefan";
    # group = "users";
    settings = {
      # Tailscale only for now
      Address = "100.96.176.26";
      Port = 4533;
      #MusicFolder = "/home/stefan/music/";
      MusicFolder = "/var/lib/navidrome/music/";
      # EnableSharing = true;
      LogLevel = "DEBUG";
      Scanner.Schedule = "@every 1h";
    };
  };

}
