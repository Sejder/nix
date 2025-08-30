{ config, lib, ... }:

let
  cfg = config.features.server;
in
{
  options.features.server = {
    enable = lib.mkEnableOption "Enable this host as a server";
  };
  
  config = lib.mkIf cfg.enable {
    features = {
      nginx.enable = true;
    };
  };
}