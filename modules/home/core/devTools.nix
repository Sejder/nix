{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.devTools;
in
{
  options.features.devTools = {
    direnv.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable direnv";
    };

    devenv.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable devenv";
    };
  };

  config = lib.mkMerge [

    (lib.mkIf cfg.direnv.enable {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };
    })

    (lib.mkIf cfg.devenv.enable {
      home.packages = with pkgs; [
        devenv
      ];
    })

  ];
}
