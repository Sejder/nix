{ config, pkgs, lib, ... }:

let
  cfg = config.features.displayManagers.sddm;
in
{
  options.features.displayManagers.sddm.enable =
    lib.mkEnableOption "Enable SDDM as display manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
  };
}