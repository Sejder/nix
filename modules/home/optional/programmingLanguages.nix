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

    nix.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nix";
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

    R.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable R";
    };

    c-sharp.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable c#";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        nixd
        nixfmt-rfc-style
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
      ];
      
      programs.nvf.settings.vim.languages.nix.enable = true;
    })
    
    (lib.mkIf cfg.python.enable {
      home.packages = with pkgs; [
        uv
        python312
        jetbrains.pycharm-professional
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.pylint
        ms-python.vscode-pylance
        ms-python.black-formatter
      ];

      programs.vscode.profiles.default.userSettings = {
        "python.defaultInterpreterPath" = "/etc/profiles/per-user/${config.home.username}/bin/python";
        "python.analysis.typeCheckingMode" = "standard";
        "python.editor.defaultFormatter" = "ms-python.black-formatter";
      };
      

      programs.nvf.settings.vim.languages.python.enable = true;
    })

    (lib.mkIf cfg.java.enable {
      home.packages = with pkgs; [
        openjdk
        gradle
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        vscjava.vscode-java-pack
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
        #rustc
        #cargo
        #rust-analyzer
        #rustfmt
        #clippy
        rustup
        jetbrains.rust-rover
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
      
      programs.nvf.settings.vim.languages.rust.enable = true;
    })

    (lib.mkIf cfg.R.enable {

      home.packages = let
        sharedRPackages = with pkgs.rPackages; [
          rmarkdown
          stringi
          stringr
          bslib
          sass
          ggplot2
          dplyr
          xts
          languageserver
          pandoc
        ];
      in [
        (pkgs.rstudioWrapper.override {
          packages = sharedRPackages;
        })

        (pkgs.rWrapper.override {
          packages = sharedRPackages;
        })

        pkgs.R
        pkgs.pandoc
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        reditorsupport.r
        reditorsupport.r-syntax
      ];
      
      programs.nvf.settings.vim.languages.r.enable = true;
    })

    (lib.mkIf cfg.c-sharp.enable {
      home.packages = with pkgs; [
        jetbrains.rider
        dotnetCorePackages.dotnet_9.sdk
      ];
    })
  ];
}

