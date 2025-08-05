{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode
    #jetbrains.idea-ultimate
    discord
    spotify
    obsidian
    gparted
    nextcloud-client
    vlc
  ];
}