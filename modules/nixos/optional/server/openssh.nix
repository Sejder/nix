{ config, lib, ... }:

let
  cfg = config.features.server.ssh;
in
{
  options.features.server.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable openssh";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
    };
  };
}
