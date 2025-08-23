{ config, pkgs, lib, ... }:

let
  cfg = config.features.editors.neovim;
in
{
  options.features.editors.neovim = {
    enable = lib.mkEnableOption "Enable neovim as editor";

    programmingLanguages.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable language support for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;

      extraLuaConfig = ''
        vim.cmd("set expandtab")
        vim.cmd("set tabstop=2")
        vim.cmd("set softtabstop=2")
        vim.cmd("set shiftwidth=2")
        vim.cmd("set number")
        vim.cmd("set relativenumber")
        vim.cmd("set smartindent")
        vim.g.mapleader = " "
        
        require("lazy-bootstrap")
        require("lazy").setup("plugins")
      '';

      plugins = [
        # LSP config plugin
        {
          plugin = pkgs.vimPlugins.nvim-lspconfig;
          config = ''
            lua << EOF
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Configure inline diagnostics
            vim.diagnostic.config({
              virtual_text = {
                prefix = "",
                spacing = 2,
              },
              signs = true,
              underline = true,
              update_in_insert = true,
              severity_sort = true,
            })

            local function setup(server, opts)
              opts = opts or {}
              opts.capabilities = capabilities
              opts.on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs)
                  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
                end
                -- LSP keymaps
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "gr", vim.lsp.buf.references)
              end
              lspconfig[server].setup(opts)
            end

            -- Setup LSP servers
            setup("pyright")    -- Python
            setup("nil_ls")     -- Nix
            setup("jdtls", { cmd = { "jdtls" } }) -- Java
            setup("clangd")     -- C/C++
            EOF
          '';
        }

        {
          plugin = pkgs.vimPlugins.everforest;
          config = ''
            lua << EOF
            vim.g.everforst_background = medium
            vim.cmd.colorscheme("everforest")
            EOF
          '';
        }

        #{

        #}
        # Completion plugin
        pkgs.vimPlugins.nvim-cmp
        pkgs.vimPlugins.cmp-nvim-lsp
        pkgs.vimPlugins.luasnip
      ];
    };

    home.file.".config/nvim".source = ./config;
    home.file.".config/nvim".recursive = true;

    home.packages = with pkgs; [
      pyright
      nil
      jdt-language-server
      clang-tools

      ripgrep
      gcc
      tree-sitter
    ];
  };
}
