{
  pkgs,
  ...
}: {
  systemd.services."kirkbot" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "kirkbot, my Discord bot";

    # Ensure it is enabled and starts automatically
    enable = true;

    serviceConfig = {
      Type = "simple";
      User = "stefan";
      ExecStart = "/run/current-system/sw/bin/bash /home/stefan/kirkbot/start.sh";
      Restart = "always";
    };
  };
}
