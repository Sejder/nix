{ config, pkgs, ... }:

{
  systemd.services.immich-docker-compose = {
    description = "Immich Docker Compose";
    after = [ "docker.service" ];
    serviceConfig.ExecStart = "${pkgs.zsh}/bin/zsh /home/mikke/modules/nixos/server/immich/start.sh";
    serviceConfig.Restart = "always";
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker.enable = true;
}
