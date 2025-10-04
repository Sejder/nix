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

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/e3c53c2c-8375-4ad3-bd2a-daf94a419318";
      fsType = "ext4";
    };
    
  system.stateVersion = "25.05";
}
