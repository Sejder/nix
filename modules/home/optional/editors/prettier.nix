{
  config,
  pkgs,
  ...
}: let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
    sha256 = "sha256:02w5j06nl2gddh9ifz1647b8bilhzkqg9c93f14cl4k0kq9c8fl1";
  }) {inherit (pkgs) system;};
in {
  nixpkgs.overlays = [
    (final: prev: {
      prettier = unstable.nodePackages.prettier;

      nodePackages =
        prev.nodePackages
        // {
          prettier = unstable.nodePackages.prettier;
        };
    })
  ];
}
