{ config, lib, ... }:
let
  cfg = config.features.settings.boot;
  deviceCfg = config.device;
in

{
  options.features.settings.boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Boot";
    };

    autoBoot.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable autoboot";
    };
  };

  config = lib.mkIf cfg.enable {
    # Bootloader setup
    boot = {
      plymouth = {
        enable = true;
      };
      consoleLogLevel = 0;  
      kernelParams = [ 
        "quiet"
        "loglevel=0"
        ];  
      initrd.verbose = false;
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = if cfg.autoBoot.enable then 5 else null;
        grub = {
          enable = true;
          efiSupport = true;
          useOSProber = true;
          device = "nodev";
          extraEntries = ''
            menuentry "Reboot into UEFI Firmware Settings" {
              fwsetup
            }
          '';
          default = "0";
          splashImage = null;
          theme = ../../../../assets/grubThemes/Particle-window/${deviceCfg.resolution};
        };
      };
    }; 
  };
}