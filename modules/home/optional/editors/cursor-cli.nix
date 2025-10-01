{ config, pkgs, lib, ... }:

let
  cfg = config.features.editors.cursor-cli;

  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "sha256-0m27AKv6ka+q270dw48KflE0LwQYrO7Fm4/2//KCVWg=";
  }) { inherit (pkgs) system; config = { allowUnfree = true; }; };
in
{
  options.features.editors.cursor-cli.enable =
    lib.mkEnableOption "Enable cursor-cli as editor";
  config = lib.mkIf cfg.enable {
    home.packages = [
      unstable.cursor-cli
    ];
  };
}
