{
  config,
  lib,
  ...
}:
let
  cfg = config.allowUnfree;
in
{
  options.allowUnfree = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow unfree packages";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
  };
}
