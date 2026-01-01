{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.server.ytdownload;
in
{
  options.features.server.ytdownload = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.features.server.enable;
      description = "Enable YouTube download service";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8001;
      description = "Port number for ytdownload service to listen on";
    };
  };

  config = lib.mkIf cfg.enable {
    # Add nginx configuration if you want to proxy it
    services.nginx = {
      virtualHosts."ytdownload.${config.networking.hostName}" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            proxyWebsockets = true; # For real-time output streaming
            extraConfig = ''
              proxy_buffering off;
              proxy_cache off;
            '';
          };
        };
      };
    };

    systemd.services.ytdownload = {
      description = "YouTube Download Flask Application";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        User = "ytdownload";
        Group = "ytdownload";
        WorkingDirectory = "/var/lib/ytdownload";

        Environment = [
          "PYTHONPATH=/var/lib/ytdownload"
          "FLASK_APP=app.py"
          "FLASK_ENV=production"
          "PATH=${
            lib.makeBinPath (
              with pkgs;
              [
                yt-dlp
                rclone
                (writeShellScriptBin "ytdownload" ''cd "$PWD" && ${yt-dlp}/bin/yt-dlp -o "Videos/%(title)s.%(ext)s" "$@"'')
              ]
            )
          }:/run/current-system/sw/bin"
        ];

        ExecStart = "${pkgs.uv}/bin/uv run gunicorn --bind 0.0.0.0:${toString cfg.port} --workers 1 --timeout 300 app:app";

        Restart = "always";
        RestartSec = "10s";

        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          "/var/lib/ytdownload"
          "/tmp"
        ];
      };

      wants = [
        "ytdownload-setup.service"
        "ytdownload-script-setup.service"
      ];
    };

    systemd.services.ytdownload-setup = {
      description = "Setup YouTube Download Application Environment";
      wantedBy = [ "multi-user.target" ];
      before = [ "ytdownload.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script =
        let
          configDir = builtins.toString ./.;
        in
        ''
          mkdir -p /var/lib/ytdownload

          # Symlink your app.py and other files
          ln -sf ${configDir}/app.py /var/lib/ytdownload/app.py

          # If you have a pyproject.toml, symlink it too
          if [ -f ${configDir}/pyproject.toml ]; then
            ln -sf ${configDir}/pyproject.toml /var/lib/ytdownload/pyproject.toml
          fi

          # If you have a uv.lock file, symlink it too
          if [ -f ${configDir}/uv.lock ]; then
            ln -sf ${configDir}/uv.lock /var/lib/ytdownload/uv.lock
          fi

          # Set ownership
          chown -R ytdownload:ytdownload /var/lib/ytdownload
          chmod 755 /var/lib/ytdownload
        '';
    };

    # Create the ytdownload user and group
    users.users.ytdownload = {
      isSystemUser = true;
      group = "ytdownload";
      home = "/var/lib/ytdownload";
      createHome = true;
    };

    users.groups.ytdownload = { };

    # Install required packages system-wide
    environment.systemPackages = with pkgs; [
      uv
      python312
      rclone
      # Add ytdownload package here if it exists in nixpkgs
      # ytdownload
      # Or create a wrapper for yt-dlp:
    ];
  };
}
