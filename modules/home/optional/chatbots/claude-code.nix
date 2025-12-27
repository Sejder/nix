{
  config,
  pkgs,
  lib,
  unstable-pkgs,
  claude-desktop,
  ...
}: let
  cfg = config.features.chatbots.claude-code;
in {
  options.features.chatbots.claude-code = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable claude-code";
    };
  };

  config = lib.mkIf (cfg.enable && config.features.apps.enable) {
    home.packages = with pkgs;
      [
        nodejs_20
      ]
      ++ (with unstable-pkgs; [
        claude-code
        claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs
      ]);

    programs.vscode.profiles.default.extensions = with unstable-pkgs.vscode-extensions; [
      #anthropic.claude-code
    ];
  };
}
