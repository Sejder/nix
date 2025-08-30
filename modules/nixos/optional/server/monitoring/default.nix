{ config, lib, ... }:

let
  cfg = options.features.server.monitoring;
in
{
  options.features.server.monitoring = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable monitoring";
    };

    glances.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable glances";
    };

    cockpit.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable Cockpit";
    };
  };
}