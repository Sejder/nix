{ config, pkgs, lib, ... }:
let
  cfg = config.features.git;
in
{
  options.features.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable git";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
    ];

    programs.git = {
      enable = true;
      userName  = "Mikkelsej";
      userEmail = "mikkel.sejdelin@gmail.com";

      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
        init.defaultBranch = "main";
      };
    };
  };
}