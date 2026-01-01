{
  lib,
  config,
  ...
}:
let
  cfg = config.device;
in
{
  options.device = lib.mkOption {
    type = lib.types.submodule {
      options = {
        type = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Select device type";
        };
        resolution = lib.mkOption {
          type = lib.types.enum [
            "1080p"
            "2k"
          ];
          default = "1080p";
          description = "Select display resolution for GRUB theme";
        };
      };
    };
    default = {
      type = "";
      resolution = "1080p";
    };
    description = "Device configuration";
  };

  config = {
    assertions = [
      {
        assertion = cfg.type != "";
        message = "Device type must be set at the host level (device.type = ...).";
      }
    ];

    services = lib.mkMerge [
      {
        tlp.enable = true;
      }

      (lib.mkIf (cfg == "laptop") {
        logind = {
          lidSwitch = "ignore";
          lidSwitchExternalPower = "ignore";
          lidSwitchDocked = "ignore";
        };
        tlp.settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "on";
        };
      })

      (lib.mkIf (cfg.type == "desktop") {
        tlp.settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        };
      })

      (lib.mkIf (cfg.type == "server") {
        tlp.settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
        };
      })
    ];
  };
}
