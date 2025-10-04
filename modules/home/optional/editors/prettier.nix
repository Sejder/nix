{ config, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
sha256 = "sha256-O7eHcgkQXJNygY6AypkF9tFhsoDQjpNEojw3eFs73Ow=";
  }) { inherit (pkgs) system; };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      prettier = unstable.nodePackages.prettier;

      nodePackages = prev.nodePackages // {
        prettier = unstable.nodePackages.prettier;
      };
    })
  ];
}
