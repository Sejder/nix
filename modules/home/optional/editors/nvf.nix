{ config, lib, inputs, ... }:

let
  cfg = config.features.editors.nvf;
in
{
  options.features.editors.nvf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nvf";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          theme = {
            enable = true;
            name = "everforest";
            style = "medium";
          };

          statusline = {
            lualine = {
              enable = true;
              theme = "everforest";
            };
          };

          tabline = {
            nvimBufferline.enable = true;
          };

          git = {
            enable = true;
            gitsigns.enable = true;
          };

          autocomplete = {
            nvim-cmp = {
              enable = true;
            };
          };

          lsp = {
            enable = true;
          };
          
          telescope.enable = true;
          filetree.nvimTree.enable = true;

          viAlias = true;
          vimAlias = true;

          languages = {
            enableFormat = true;
            enableTreesitter = true;

            nix.enable = true;
            python.enable = true;
            java.enable = true;
            html.enable = true;
            css.enable = true;
          };
        };
      };
    };
  };
}