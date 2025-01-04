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
      ExecStart = "${pkgs.coreutils}/bin/sleep infinity"; # Replace with your actual command
      Restart = "always";
    };
  };
}
