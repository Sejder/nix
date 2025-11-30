{config, pkgs, lib, ... }:

let
  cfg = config.features.cli.tmux;
in
{
  options.features.cli.tmux.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}