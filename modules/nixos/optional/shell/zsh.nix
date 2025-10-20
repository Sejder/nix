{config, pkgs, lib, ... }:

let
  cfg = config.features.shell.zsh;
in
{
  options.features.shell.zsh.enable = lib.mkOption {
    type = lib.types.bool;
    default =
      let
        users = config.systemUsers.users or ["mikke"];
        anyUserHasZsh = lib.any (user:
          config.home-manager.users.${user}.features.shell.zsh.enable or false
        ) users;
      in
        anyUserHasZsh;
    description = "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };

    # Set zsh as shell for all users who have it enabled
    users.users = lib.mkMerge (map (user:
      lib.mkIf (config.home-manager.users.${user}.features.shell.zsh.enable or false) {
        ${user}.shell = pkgs.zsh;
      }
    ) config.systemUsers.users);
  };
}