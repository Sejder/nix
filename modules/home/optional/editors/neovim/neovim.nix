{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.features.editors.neovim;
in
{
  options.features.editors.neovim = {
    enable = lib.mkEnableOption "Enable neovim as editor";

    programmingLanguages.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable language support for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;

      extraLuaConfig = ''
        require("lazy-bootstrap")
        require("options")
        require("lazy").setup("plugins")
      '';

    };

    home.file.".config/nvim".source = ./config;
    home.file.".config/nvim".recursive = true;

    home.packages = with pkgs; [
      pyright
      nil
      jdt-language-server
      clang-tools

      ripgrep
      gcc
      tree-sitter
    ];
  };
}
