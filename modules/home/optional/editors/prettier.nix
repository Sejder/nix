{ config, pkgs, ... }:

let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
sha256 = "sha256:1pqk3n7dv3ccxcyqdhpbd7d981agvbgwdbn3pipaik4q8aqk7fci";
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
