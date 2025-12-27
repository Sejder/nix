{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.programmingLanguages;
  jetbrainsCfg = config.features.editors.jetbrains;
in {
  options.features.editors.jetbrains = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable JetBrains Editors";
    };
  };

  config = lib.mkIf (jetbrainsCfg.enable && config.features.apps.enable) {
    home.file.".config/jetbrains-vmoptions".text = ''
      -Dawt.toolkit.name=WLToolkit
      -Xms512m
      -Xmx2048m
      -XX:+UseG1GC
    '';

    home.sessionVariables =
      (
        if cfg.java.enable
        then {IDEA_VM_OPTIONS = "${config.home.homeDirectory}/.config/jetbrains-vmoptions";}
        else {}
      )
      // (
        if cfg.python.enable
        then {PYCHARM_VM_OPTIONS = "${config.home.homeDirectory}/.config/jetbrains-vmoptions";}
        else {}
      )
      // (
        if cfg.c-sharp.enable
        then {RIDER_VM_OPTIONS = "${config.home.homeDirectory}/.config/jetbrains-vmoptions";}
        else {}
      )
      // (
        if cfg.rust.enable
        then {RUSTROVER_VM_OPTIONS = "${config.home.homeDirectory}/.config/jetbrains-vmoptions";}
        else {}
      );

    home.packages = lib.concatLists [
      (lib.optional cfg.java.enable pkgs.jetbrains.idea)
      (lib.optional cfg.python.enable pkgs.jetbrains.pycharm)
      (lib.optional cfg.c-sharp.enable pkgs.jetbrains.rider)
      (lib.optional cfg.rust.enable pkgs.jetbrains.rust-rover)
    ];
  };
}
