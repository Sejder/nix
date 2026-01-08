{
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "home";
  networking.firewall.allowedTCPPorts = [80 443 3000];
  systemUsers = {
    users = [ "mikke" ];
    primaryUser = "mikke";
  };

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
    virtualisation.docker.enable = true;
  };

  fileSystems."/ssd" = {
    device = "/dev/disk/by-uuid/d12145c6-0924-4d3e-a596-dcc7bcc24a63";
    fsType = "ext4";
  };

  system.stateVersion = "25.05";
}
