{ config, pkgs, lib, ... }:
let cfg = config.features.programmingLanguages; in
{
    options.features.programmingLanguages.R.enable = lib.mkOption {
      type = lib.types.bool;
      default = let
        users = config.systemUsers.users or ["mikke"];
        anyUserHasR =
          lib.any (
            user:
              config.home-manager.users.${user}.features.programmingLanguages.R.enable or false
          )
          users;
      in
        anyUserHasR;
      description = "Enable R fix";
    };

    config = lib.mkIf cfg.R.enable {
        #systemd.tmpfiles.rules = [
        #    "L+ /usr/bin/which - - - - ${pkgs.which}/bin/which"
        #];

        #environment.systemPackages = with pkgs; [
        #    which
        #];

    };
}
