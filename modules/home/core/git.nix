{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.git;
in {
  options.features.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable git";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      lazygit
      gh
    ];

    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Sejder";
          email = "mikkel.sejdelin@gmail.com";
        };
        push = {
          autoSetupRemote = true;
        };
        init.defaultBranch = "main";
      };
    };
  };
}
