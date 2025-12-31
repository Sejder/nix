{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.features.displayManagers.gdm;
in
{
  options.features.displayManagers.gdm.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable GDM";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      gdm = {
        enable = true;

      };
    };
  };
}
