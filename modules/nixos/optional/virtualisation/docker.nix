{config, pkgs, lib, ... }:

let
  cfg = config.features.virtualisation.docker;
in
{
  options.features.virtualisation.docker = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Docker";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      virtualisation.docker.enable = true;

      users.users.${config.systemUsers.primaryUser}.extraGroups = [ "docker" ];
    })
  ];
}