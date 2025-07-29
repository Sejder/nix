{
  systemd.services.duckdns-updater = {
    description = "DuckDNS IP updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/mikke/nix/modules/nixos/server/duckdns/update.sh";
    };
  };

  systemd.timers.duckdns-updater = {
    description = "Run DuckDNS updater every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      Unit = "duckdns-updater.service";
    };
  };
}
