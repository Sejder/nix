{ pkgs, lib, config, ... }:

let
  cfg = config.device;
in

{
  options = {
    device = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Specify the type of device: laptop, desktop, or server.";
    };
  };

  config = {
    assertions =
      [ { assertion = config.device != null;
          message = "Device type must be set";
        }
      ];
    
    services.tlp = lib.mkIf (config.device == "laptop") {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    } // lib.mkIf (config.device == "desktop") {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      };
    } // lib.mkIf (config.device == "server") {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_BOOST_ON_AC = 0;
      };
    };
  };
}
