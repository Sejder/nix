{ config, pkgs, lib, ... }:

let
  cfg = config.features.browsers.firefox;
in
{
  options.features.browsers.firefox.enable =
    lib.mkEnableOption "Enable firefox as browser";

  config = lib.mkIf cfg.enable {

    programs.firefox = {
      enable = true;
    };

    home.packages = with pkgs; [
      firefox
    ];
  };
}