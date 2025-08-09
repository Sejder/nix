{ config, pkgs, lib, ... }:

let
  cfg = config.features.displaymanagers.sddm;
in
{
  options.features.displaymanagers.sddm.enable =
    lib.mkEnableOption "Enable SDDM as display manager";
  
  options.features.displaymanagers.sddm.enable =
    lib.mkEnableOption "Enable SDDM as display manager";

  config = lib.mkIf cfg.enable {
    services.displaymanagers.sddm.enable = true;
  };
}