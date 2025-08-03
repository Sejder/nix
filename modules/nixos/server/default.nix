{ config, pkgs, ... }:

{
  imports = [
    ./tailscale.nix
    ./nextcloud.nix
    ./openssh.nix
    ./immich.nix
    ./nginx.nix
  ];


  
}
