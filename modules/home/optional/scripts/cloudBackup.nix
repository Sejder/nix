{ config, lib, pkgs, ... }:

let
  cfg = config.features.scripts.cloudBackup;
  backupCmd = ''
    ${pkgs.rsync}/bin/rsync -av --delete "$HOME/Nextcloud/" "$HOME/cloudBackup/"
  '';
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
    systemd.user.services.cloudBackup = {
      Unit = {
        Description = "Backup Nextcloud folder to NextcloudBackup";
      };
      Service = {
        Type = "oneshot";
        ExecStart = backupCmd;
      };
    };

    systemd.user.timers.cloudBackup = {
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
      (pkgs.writeShellScriptBin "cloudBackup" backupCmd)
    ];
  };
}
