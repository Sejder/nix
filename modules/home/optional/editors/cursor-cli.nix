{
  config,
  pkgs,
  lib,
  ...
}: 
let 
  cfg = config.features.editors.cursor-cli;
in
{
  options.features.editors.cursor-cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable cursor-cli";
    };
  };


  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cursor-cli
    ];

  };
}
