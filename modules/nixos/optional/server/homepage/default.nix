{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.server.homepage;
in
{
  options.features.server.homepage = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.features.server.enable;
      description = "Enable homepage";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8000;
      description = "Port number for homepage to listen on";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      virtualHosts."${config.networking.hostName}" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
          };
        };
      };
    };

    systemd.services.homepage = {
      description = "Homepage Flask Application";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        User = "homepage";
        Group = "homepage";
        WorkingDirectory = "/var/lib/homepage";

        Environment = [
          "PYTHONPATH=/var/lib/homepage"
          "FLASK_APP=main.py"
          "FLASK_ENV=production"
        ];

        ExecStart = "${pkgs.uv}/bin/uv run gunicorn --bind 0.0.0.0:${toString cfg.port} --workers 4 main:app";

        Restart = "always";
        RestartSec = "10s";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/lib/homepage" ];
      };

      wants = [ "homepage-setup.service" ];
    };

    systemd.services.homepage-setup = {
      description = "Setup Homepage Application Environment";
      wantedBy = [ "multi-user.target" ];
      before = [ "homepage.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script =
        let
          configDir = builtins.toString ./.;
        in
        ''
          mkdir -p /var/lib/homepage
          ln -sf ${configDir}/main.py /var/lib/homepage/main.py
          if [ -f ${configDir}/pyproject.toml ]; then
            ln -sf ${configDir}/pyproject.toml /var/lib/homepage/pyproject.toml
          fi
          if [ -f ${configDir}/uv.lock ]; then
            ln -sf ${configDir}/uv.lock /var/lib/homepage/uv.lock
          fi
          chown -R homepage:homepage /var/lib/homepage
          chmod 755 /var/lib/homepage

        '';

      postStart = ''
        systemd-run --on-active=2s systemctl restart homepage.service
      '';
    };

    users.users.homepage = {
      isSystemUser = true;
      group = "homepage";
      home = "/var/lib/homepage";
      createHome = true;
    };

    users.groups.homepage = { };

    environment.systemPackages = with pkgs; [
      uv
      python312
    ];
  };
}
