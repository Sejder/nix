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
      obsidian
      spotify
      discord
      gparted
      nextcloud-client
      vlc
      mattermost-desktop
      zip
      unzip
      wget
      jetbrains-toolbox
      unityhub
      
    ];

    features.scripts.obsidian-startup.enable = true;
    features.documentWriters.latex.enable = true;
    features.documentWriters.typst.enable = true;

  };
}