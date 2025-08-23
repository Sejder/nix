{ config, pkgs, ... }:


{

  home.file.".config/nvim".source = ./config;
  home.file.".config/nvim".recursive = true;

  programs.neovim = {
    enable = true;
    extraConfig = "";
    withNodeJs = true;
  };

  home.packages = with pkgs; [
    ripgrep # Needed for telescope
    gcc # Needed for telescope
    tree-sitter
    nixd
    black
    lua-language-server
  ];
}
