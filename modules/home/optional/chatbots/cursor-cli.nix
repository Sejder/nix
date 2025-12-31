{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.features.chatbots.cursor-cli;
in
{
  options.features.chatbots.cursor-cli = {
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
