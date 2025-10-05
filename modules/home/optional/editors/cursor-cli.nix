{ config, pkgs, lib, ... }:

let
  cfg = config.features.editors.cursor-cli;

  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = "sha256:1pqk3n7dv3ccxcyqdhpbd7d981agvbgwdbn3pipaik4q8aqk7fci";
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
