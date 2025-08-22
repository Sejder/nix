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
    nautilus.test.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nautilus";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nautilus.test.enable {
      services.gvfs.enable = true;

      nixpkgs.overlays = [
        (final: prev: {
          nautilus = prev.nautilus.overrideAttrs (nprev: {
            buildInputs =
              nprev.buildInputs
              ++ (with pkgs.gst_all_1; [
                gst-plugins-good
                gst-plugins-bad
              ]);
          });
        })
      ];

      environment.systemPackages = with pkgs; [ 
        nautilus 
        libheif 
        libheif.out 
      ];
      environment.pathsToLink = [ "share/thumbnailers" ];
    })

    (lib.mkIf cfg.nautilus.enable {
      environment.systemPackages = with pkgs [
        nautilus
      ];
    })
  ];
}