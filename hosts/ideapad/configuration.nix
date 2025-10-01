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
    virtualisation.docker.enable = true;
  };

  nixpkgs.overlays = [

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