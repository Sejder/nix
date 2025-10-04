{ config, pkgs, ... }:

{
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
}
