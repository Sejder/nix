{config, pkgs, lib, ... }:

let
  cfg = config.features.scripts.cloudBackup;
in
{
  options.features.scripts.cloudBackup = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable cloudBackup";
    };


  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.nextcloud-backup = {
      Unit = {
        Description = "Backup Nextcloud folder to NextcloudBackup";
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.rsync}/bin/rsync -av --delete "$HOME/Nextcloud/" "$HOME/NextcloudBackup/"
        '';
      };
    };

    systemd.user.timers.nextcloud-backup = {
      Unit = {
        Description = "Run Nextcloud backup once a day";
      };
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    home.packages = with pkgs; [
      rsync
    ];
  };
}
