{ config, pkgs, ... }:

{
  imports = [
    ./tailscale.nix
    #./nextcloud/default.nix
    ./openssh.nix
    #./immich/default.nix
    ./nginx.nix
  ];

  
}
