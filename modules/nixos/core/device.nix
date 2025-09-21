{ pkgs, lib, config, ... }:
let
  cfg = config.device;
in
{
  options.device = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Select device type";
  };

  config = {
    assertions = [
      {
        assertion = cfg != "";
        message = "Device type must be set at the host level (device = ...).";
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
      
      (lib.mkIf (cfg == "desktop") {
        tlp.settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        };
      })
      
      (lib.mkIf (cfg == "server") {
        tlp.settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
          CPU_BOOST_ON_AC = 0;
        };
      })
    ];
  };
}