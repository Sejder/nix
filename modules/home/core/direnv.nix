{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.direnv;
in {
  options.features.direnv.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
