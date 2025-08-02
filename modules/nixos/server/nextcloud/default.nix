{ config, pkgs, ... }:

{
  systemd.services.nextcloud-docker-compose = {
    description = "Nextcloud Docker Compose";
    after = [ "docker.service" ];
    serviceConfig.ExecStart = "${pkgs.zsh}/bin/zsh /home/mikke/modules/nixos/server/nextcloud/start.sh";
    serviceConfig.Restart = "always";
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = with pkgs; [
    docker
  ];

  virtualisation.docker.enable = true;
}
