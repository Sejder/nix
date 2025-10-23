{
  config,
  pkgs,
  lib,
  ...
}: 
let 
  cfg = config.features.chatbots.github-copilot;
in
{
  options.features.chatbots.github-copilot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Github Copilot";
    };
  };


  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      copilot-cli
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        github.copilot
      ];
  };
}
