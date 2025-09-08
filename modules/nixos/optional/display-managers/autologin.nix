{ config, lib, ... }:
let
  cfg = config.features.displayManagers.autoLogin;
in
{
  options.features.displayManagers.autoLogin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable autologin";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.autoLogin = {
      enable = true;
      user = "mikke";
    };
  };
}