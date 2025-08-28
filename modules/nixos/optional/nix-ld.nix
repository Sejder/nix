{config, pkgs, lib, ... }:

let
  cfg = config.features.nix-ld;
in
{
  options.features.nix-ld = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nix-ld";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.nix-ld.enable = true;
    })
  ];
}