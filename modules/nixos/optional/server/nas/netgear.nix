{ config, lib, ... }:

let
  cfg = config.features.server.nas.netgear;
in
{
  options.features.server.nas.netgear = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable netgear nas";
    };
  };
  
  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "netgear.${config.networking.hostName}" = {
          locations."/" = {
            proxyPass = "http://192.168.87.165:80";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              client_max_body_size 100G;           
              proxy_read_timeout 600s;
              proxy_send_timeout 600s;
            '';
        };
      };

      environment.systemPackages = with pkgs; [
        nfs-utils
      ];
      services.rpcbind.enable = true;

      fileSystems."/mnt/test" = {
        device = "192.168.87.165:/c/data";
        fsType = "nfs";
        options = [ "vers=3" ];
      };
    };
  };
}