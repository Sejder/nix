{ config, pkgs, lib, ...}:

let
  cfg = config.services.desktopenv.hyprland;
in

{
  imports = lib.mkIf cfg [
    ./hyprland.nix
  ];

  config = lib.mkIf cfg {
    programs.hyprland.enable = true;
  };
}
