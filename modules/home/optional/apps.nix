{
  config,
  pkgs,
  unstable-pkgs,
  lib,
  ...
}: let
  cfg = config.features.apps;
in {
  options.features.apps = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable apps";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vscode
      pkgs.obsidian
      pkgs.spotify
      pkgs.discord
      pkgs.gparted
      pkgs.nextcloud-client
      pkgs.vlc
      pkgs.mattermost-desktop
      pkgs.zip
      pkgs.unzip
      pkgs.wget
      pkgs.unityhub
    ];

    features.scripts.obsidian-startup.enable = true;
    features.documentWriters.latex.enable = true;
    features.documentWriters.typst.enable = true;
  };
}
