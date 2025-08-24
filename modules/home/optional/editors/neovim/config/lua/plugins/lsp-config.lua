return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()

    local lspconfig = require("lspconfig")

    -- Buffer-local key mapping helper
    local function map(bufnr, mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true })
    end

    local function on_attach(_, bufnr)
      map(bufnr, "n", "gd", vim.lsp.buf.definition)
      map(bufnr, "n", "K", vim.lsp.buf.hover)
      map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename)
      map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action)
      map(bufnr, "n", "gr", vim.lsp.buf.references)
    end

    vim.diagnostic.config({
      virtual_text = { prefix = "", spacing = 2 },
      signs = true,
      underline = true,
      update_in_insert = true,
      severity_sort = true,
    })

    local function setup_server(server_name, opts)
      opts = opts or {}
      opts.capabilities = capabilities
      opts.on_attach = on_attach
      lspconfig[server_name].setup(opts)
    end

    local servers = {
      "pyright", -- Python
      "nil_ls",  -- Nix
      { "jdtls", { cmd = { "jdtls" } } }, -- Java
      "clangd",  -- C/C++
    }

    for _, srv in pairs(servers) do
      if type(srv) == "table" then
        setup_server(srv[1], srv[2])
      else
        setup_server(srv)
      end
    end
  end,
}
