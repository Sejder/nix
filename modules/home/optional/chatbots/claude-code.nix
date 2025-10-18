{
  config,
  pkgs,
  lib,
  ...
}: 
let 
  cfg = config.features.chatbots.claude-code;
in
{
  options.features.chatbots.claude-code = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable claude-code";
    };
  };


  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      claude-code
      nodejs-slim # Required for claude-code
    ];

    programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        anthropic.claude-code
      ];
  };
}
