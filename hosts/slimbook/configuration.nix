{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "slimbook";

  systemUsers = {
    users = [ "mikke" ];
    primaryUser = "mikke";
  };

  device = {
    type = "laptop";
    resolution = "1080p";
  };

  features = {
    nix-ld.enable = true;
  };

  system.stateVersion = "25.05";

}
