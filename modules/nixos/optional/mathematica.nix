{
  pkgs,
  config,
  lib,
  ...
}: # 1. Remove makeDesktopItem from here
let
  cfg = config.features.apps.mathematica;
in
{
  options.features.apps.mathematica = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable mathematica";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # 2. Access it via pkgs.makeDesktopItem
      (pkgs.makeDesktopItem {
        name = "mathematica";
        desktopName = "Mathematica";
        exec = "${pkgs.mathematica}/bin/wolframnb";
      })
      pkgs.mathematica
    ];
  };
}
