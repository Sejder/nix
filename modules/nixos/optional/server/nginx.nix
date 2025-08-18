{ config, pkgs, lib, ... }:

let
  cfg = config.features.server.nginx;
in
{
  options.features.server.nginx.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.features.server.enable;
    description = "Enable nginx as proxy manager";
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts."${config.networking.hostName}" = {
        locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:5000";
            };
          };
      };
    };

    environment.systemPackages = with pkgs; [
      nginx
    ];
  };
}