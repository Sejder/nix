{config, pkgs, lib, ... }:

let
  cfg = config.features.shell.zsh;
in
{
  options.features.shell.zsh.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.home-manager.users.mikke.features.shell.zsh.enable;
    description = "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };

    users.users.mikke = {
      shell = pkgs.zsh;
    };
  };
}