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
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.pylint
        ms-python.vscode-pylance
        ms-pyright.pyright
      ];
      
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
      ];
      
      programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
      ];
      
      programs.nvf.settings.vim.languages.rust.enable = true;
    })

    (lib.mkIf cfg.R.enable {

      # For RStudio packages SOCI
      nixpkgs.overlays = [
        (final: prev: {
          soci = prev.soci.overrideAttrs (old: {
            version = "4.0.3";
            src = prev.fetchFromGitHub {
              owner = "SOCI";
              repo = "soci";
              rev = "v4.0.3";
              sha256 = "sha256-HsQyHhW8EP7rK/Pdi1TSXee9yKJsujoDE9QkVdU9WIk=";
            };

            patches = [];

            cmakeFlags = (old.cmakeFlags or []) ++ [
                "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
              ];
          });

        })
      ];
      

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
        #reditorsupport.r-syntax
      ];
      
      programs.nvf.settings.vim.languages.r.enable = true;
    })
  ];
}

