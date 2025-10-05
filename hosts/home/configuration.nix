{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "home";

  device = {
    type = "server";
    resolution = "1080p";
  };

  features = {
    nix-ld.enable = true;
    server = {
      enable = true;
      llm.ollama.enable = true;
    };
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/150C-2773";
    fsType = "ext4";
  };

  system.stateVersion = "25.05";
}
