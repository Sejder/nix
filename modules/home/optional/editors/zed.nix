{
  config,
  unstable-pkgs,
  lib,
  ...
}:
let
  cfg = config.features.editors.zed;
in
{
  options.features.editors.zed.enable = lib.mkEnableOption "Enable zed as editor";

  config = lib.mkIf (cfg.enable && config.features.apps.enable) {
    home.packages = with unstable-pkgs; [
      zed-editor
    ];

    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "git-firefly"
      ];
      package = unstable-pkgs.zed-editor;
    };
  };
}
