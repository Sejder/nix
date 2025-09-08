{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.programmingLanguages;
in {
  options.features.programmingLanguages = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Programming Languages";
    };

    python.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable python";
    };

    java.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable java";
    };

    c.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable c";
    };

    rust.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable rust";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.python.enable {
      home.packages = with pkgs; [
        python3Full
        uv
        black
      ];
      programs.nvf.settings.vim.languages.python.enable = true;
    })

    (lib.mkIf cfg.java.enable {
      home.packages = with pkgs; [
        openjdk
        gradle
      ];
      programs.nvf.settings.vim.languages.java.enable = true;
    })

    (lib.mkIf cfg.c.enable {
      home.packages = with pkgs; [
        gcc
      ];
      programs.nvf.settings.vim.languages.clang.enable = true;
    })

    (lib.mkIf cfg.rust.enable {
      home.packages = with pkgs; [
        rustc
        cargo
        rust-analyzer
        rustfmt
        clippy
      ];
      programs.nvf.settings.vim.languages.rust.enable = true;
    })
  ];
}

