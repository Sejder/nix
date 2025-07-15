{ config, pkgs, ... }:

{
  services = {
    displayManager = {
      defaultSession = "hyprland";
      autoLogin = {
        enable = true;
        user = "mikke";
      };
      sddm = {
        enable = true;
        theme = "breeze";
        wayland.enable = true;
        settings = {
          Theme = {
            Background = "/etc/sundown-over-sea.jpg";
          };
          General = {
            Locale = "da_DK.UTF-8";
            TimeZone = "Europe/Copenhagen";
            GreeterEnvironment = "TZ=Europe/Copenhagen";   
            Background = "/etc/sundown-over-sea.jpg";       
          };
        };
      };
    };
  };
}