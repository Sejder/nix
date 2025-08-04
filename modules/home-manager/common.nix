{ config, pkgs, ... }:

{
  imports = [ 
    ./programming_languages/default.nix
    ./git.nix
    ./neovim/default.nix
    ./zsh/default.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    yt-dlp
  ];

} 
