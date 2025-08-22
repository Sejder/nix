{config, pkgs, lib, ... }:

let
  cfg = config.features.apps;
in
{
  options.features.apps = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable apps";
    };


  };

  config = lib.mkIf cfg.enable {
    
    home.packages = with pkgs; [
      vscode
      jetbrains.idea-community
      obsidian
      spotify
      discord
      gparted
      nextcloud-client
      vlc
    ];
  };
}