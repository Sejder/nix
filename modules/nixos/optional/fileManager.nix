{config, pkgs, lib, ... }:

let
  cfg = config.features.fileManagers;
in
{
  options.features.fileManagers = {
    nautilus.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nautilus";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nautilus.enable {
      environment.systemPackages = with pkgs; [
        nautilus
        libheif 
        libheif.out 

        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        zip
      ];

      environment.pathsToLink = [ "share/thumbnailers" ];

      services.gvfs.enable = true;

    })
  ];
}