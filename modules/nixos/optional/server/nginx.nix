{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.server.nginx;
in {
  options.features.server.nginx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable nginx as proxy manager";
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      clientMaxBodySize = "1G";
    };
    environment.systemPackages = with pkgs; [
      nginx
    ];
  };
}

