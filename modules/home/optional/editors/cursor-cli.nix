{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.editors.cursor-cli;

  unstable =
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      sha256 = "sha256:02w5j06nl2gddh9ifz1647b8bilhzkqg9c93f14cl4k0kq9c8fl1";
    }) {
      inherit (pkgs) system;
      config = {allowUnfree = true;};
    };
in {
  options.features.editors.cursor-cli.enable =
    lib.mkEnableOption "Enable cursor-cli as editor";
  config = lib.mkIf cfg.enable {
    home.packages = [
      unstable.cursor-cli
    ];
  };
}
