{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  networking.hostName = "ideapad";
  device = "laptop";

  features = {
    server.enable = false;
    nix-ld.enable = true;
  };

  nixpkgs.overlays = [
    (_: prev: {
      tailscale = prev.tailscale.overrideAttrs (old: {
        checkFlags =
          builtins.map (
            flag:
              if prev.lib.hasPrefix "-skip=" flag
              then flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
              else flag
          )
          old.checkFlags;
      });
    })
    (final: prev: {
      # Pull prettier from unstable for nvf
      prettier = inputs.unstable-nixpkgs.legacyPackages.${prev.system}.nodePackages.prettier;
      
      nodePackages = prev.nodePackages // {
        prettier = inputs.unstable-nixpkgs.legacyPackages.${prev.system}.nodePackages.prettier;
      };
    })
  ];

  system.stateVersion = "25.05";
}