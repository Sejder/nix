{
  config,
  unstable-pkgs,
  lib,
  ...
}: let
  cfg = config.features.chatbots.github-copilot;
in {
  options.features.chatbots.github-copilot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Github Copilot";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with unstable-pkgs; [
      github-copilot-cli
    ];

    programs.vscode.profiles.default = {
      extensions = with unstable-pkgs.vscode-extensions; [
        github.copilot
      ];

      userSettings = {
        "chat.agent.enabled" = true;
      };
    };
  };
}
