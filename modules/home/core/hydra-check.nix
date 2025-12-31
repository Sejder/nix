{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.hydra-check;
in
{
  options.features.hydra-check.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Hydra check";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hydra-check
    ];
  };
}
