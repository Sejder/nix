{ config, pkgs, lib, ... }:

{
  imports = [
    ./firefox.nix
    ./git.nix
    ./tailscale.nix
  ];
}
