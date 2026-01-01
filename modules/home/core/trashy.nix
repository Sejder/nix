{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.trashy;
in
{
  options.features.trashy.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Trashy";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      trashy
    ];
  };
}
