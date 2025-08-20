{ config, lib, ... }:


let
  cfg = config.features.settings.audio;
in
{
  options.features.settings.audio.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable audio";
  };
  
  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
      };
  };
}