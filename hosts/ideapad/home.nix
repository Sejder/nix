{ config, pkgs, isNixOS, ... }:

let
  desktopImports = if isNixOS then [
    ./../../modules/home-manager/desktopenv/default.nix
  ] else [];

  commonImports = [
    ./../../modules/home-manager/common.nix
  ];
in
{
  home.username = "mikke";
  home.homeDirectory = "/home/mikke";
  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  home.sessionVariables = {
    EDTOR = "code";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;

  imports = commonImports ++ desktopImports;
}
