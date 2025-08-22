{ config, pkgs, lib, ... }:


let
  cfg = config.features.settings.keyring;
in
{
  options.features.settings = {
    keyring = {
      gnome.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Gnome keyring manager";
      };
    };
    
  };

  config = lib.mkMerge [

    (lib.mkIf cfg.gnome.enable {
      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages = with pkgs; [
        seahorse
      ];  
    })
  ];
}