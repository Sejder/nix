{ config, pkgs, lib, ... }:

let
  cfg = config.features.neovim;
in

{
  config = lib.mkIf cfg {
    home.file.".config/nvim".source = ./nvim-config;
    home.file.".config/nvim".recursive = true;

    programs.neovim = {
      enable = true;
      extraconfig = "";
      withnodejs = true;
    };

    home.packages = with pkgs; [
      ripgrep # needed for telescope
      gcc # needed for telescope
      tree-sitter
      nixd
      black
      lua-language-server
    ];
  };


}
