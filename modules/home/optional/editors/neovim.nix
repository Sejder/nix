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
      extraLuaConfig = ''
        require("lazy-bootstrap")
        require("options")
        require("lazy").setup("plugins")
      '';

      

      withNodeJs = true;
    };


    home.file.".config/nvim".source = ./config;
    home.file.".config/nvim".recursive = true;

    programs.neovim = {
      enable = true;

      extraLuaConfig = ''
        -- LSP and completion
        local lspconfig = require("lspconfig")
        local cmp = require("cmp")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Configure diagnostics display
        vim.diagnostic.config({
          virtual_text = {
            prefix = "",
            spacing = 2,
          },
          signs = true,       -- show signs in the gutter
          underline = true,   -- underline the offending code
          update_in_insert = true, -- don't show errors as you type
          severity_sort = true,     -- sort by severity
        })


        -- Setup completion
        cmp.setup {
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm { select = true },
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }, {
            { name = "buffer" },
          }),
        }

        -- Helper to setup LSP servers
        local function setup(server, opts)
          opts = opts or {}
          opts.capabilities = capabilities
          opts.on_attach = function(_, bufnr)
            local map = function(mode, lhs, rhs)
              vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
            end
            map("n", "gd", vim.lsp.buf.definition)
            map("n", "K", vim.lsp.buf.hover)
            map("n", "<leader>rn", vim.lsp.buf.rename)
            map("n", "<leader>ca", vim.lsp.buf.code_action)
            map("n", "gr", vim.lsp.buf.references)
          end
          lspconfig[server].setup(opts)
        end

        -- Python
        setup("pyright")

        -- Nix
        setup("nil_ls")

        -- Java
        setup("jdtls", {
          cmd = { "jdtls" },
        })

        -- C / C++
        setup("clangd")
      '';


      #plugins = with pkgs.vimPlugins; [
        # base plugins
      #  nvim-treesitter
      #  telescope-nvim
      #  gitsigns-nvim
      #  nvim-lspconfig
      #  luasnip
      #  nvim-cmp
      #  alpha-nvim
      #  nvim-autopairs
      #  which-key-nvim
      #  neo-tree-nvim
      #  lualine-nvim
      #  cmp-nvim-lsp

        # themes
      #  everforest
      #];
    };

    home.packages = with pkgs; [
      pyright              # Python
      nil                  # Nix
      jdt-language-server  # Java
      clang-tools          # provides clangd for C/C++

      ripgrep # Needed for telescope
      gcc # Needed for telescope
      
      tree-sitter
    ];
  };
}
