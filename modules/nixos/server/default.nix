{ config, pkgs, ... }:

{
  imports = [
    #./cloudflared.nix
    ./tailscale.nix
    # ./duckdns/default.nix
    # ./nextcloud.nix
    ./openssh.nix
  ];

}
