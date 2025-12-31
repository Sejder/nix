{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.scripts.cloudBackup;
  backupCmd = ''
    ${pkgs.rsync}/bin/rsync -av --delete "$HOME/Nextcloud/" "${cfg.targetDir}/"
  '';
in
{
  options.features.scripts.cloudBackup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable cloudBackup";
    };

    targetDir = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The target directory to which the Nextcloud folder will be cloned.
        This can be any valid path, e.g. "/mnt/backup/cloudBackup".
      '';
      example = "/mnt/backup/cloudBackup";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.targetDir != "";
        message = "features.scripts.cloudBackup.targetDir must be set to a non-empty value";
      }
    ];

    systemd.user.services.cloudBackup = {
      Unit = {
        Description = "Backup Nextcloud folder to ${cfg.targetDir}";
      };
      Service = {
        Type = "oneshot";
        ExecStart = backupCmd;
      };
    };

    systemd.user.timers.cloudBackup = {
      Unit = {
        Description = "Run Nextcloud backup every day at 11 AM";
      };
      Timer = {
        OnCalendar = "11:00";
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
