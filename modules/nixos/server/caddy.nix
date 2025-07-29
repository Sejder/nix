{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."localhost".extraConfig = ''
      reverse_proxy localhost:2283
    '';
  };

  environment.systemPackages = with pkgs; [
    caddy
  ];
}