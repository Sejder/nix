{config, pkgs, lib, ... }:

let
  cfg = config.features.programmingLanguages;
in
{
  options.features.programmingLanguages = {
    enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Programming Languages";
    };
  };

  config = lib.mkIf cfg.enable {
    

    home.packages = with pkgs; [

      # Python
      python3Full

      # Java
      openjdk
      gradle

      # C
      gcc

    ];  
  };
}