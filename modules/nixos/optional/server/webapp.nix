{
  config,
  lib,
  ...
}: let
  cfg = config.features.server.webapp;
in {
  options.features.server.webapp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Webapp";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      # This ONE line handles all the headers (Host, Upgrade, Real-IP) for you.
      # It prevents the "duplicate header" bug.
      recommendedProxySettings = true;

      virtualHosts."webapp.home" = {
        # Listen on port 80 (default)
        locations."/" = {
          # Forward to Dokploy's Traefik on Port 81
          proxyPass = "http://127.0.0.1:81";

          # We DO NOT need extraConfig here anymore.
        };
      };
    };
  };
}
