{
  config,
  unstable-pkgs,
  lib,
  ...
}: let
  cfg = config.features.chatbots.gemini;
in {
  options.features.chatbots.gemini = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gemini";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with unstable-pkgs; [
      gemini-cli
      antigravity
      google-chrome
    ];
  };
}
