{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.features.shell.zsh;
in
{
  options.features.shell.zsh.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      history = {
        size = 10000;
        ignoreAllDups = true;
        path = "$HOME/.zsh_history";
        ignorePatterns = [
          "rm *"
          "pkill *"
          "cp *"
        ];
      };
    };

    home.sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };

    programs.starship.enable = true;

    home.packages = with pkgs; [
      eza
      fastfetch
    ];
  };
}
