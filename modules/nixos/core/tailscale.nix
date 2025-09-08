{ config, pkgs, lib, ... }:
let
  cfg = config.features.tailscale;
in
{
  options.features.tailscale.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable tailscale";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tailscale
      ffmpeg_6-full
    ];

    services.tailscale = {
      enable = true;
    };
  };
}