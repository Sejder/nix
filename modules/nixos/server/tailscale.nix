{ config, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
