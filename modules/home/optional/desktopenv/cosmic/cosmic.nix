{ config, pkgs, lib, ... }:
let
  cfg = config.features.desktopenv.cosmic;
in
{
  options.features.desktopenv.cosmic = {
    enable = lib.mkEnableOption "Cosmic Desktop Environment";
  };
  
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      
    ];
  };
}
