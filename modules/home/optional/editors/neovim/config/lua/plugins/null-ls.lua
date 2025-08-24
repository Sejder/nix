-- lua/plugins/null-ls.lua
return {
  "jose-elias-alvarez/null-ls.nvim",
  event = "VeryLazy",  -- lazy-load when needed
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    -- Define sources (formatters, linters, code actions)
    local sources = {
      -- Python
      null_ls.builtins.formatting.black,
      null_ls.builtins.diagnostics.flake8,
      -- Lua
      null_ls.builtins.formatting.stylua,
      -- JavaScript / TypeScript
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.eslint,
      -- Nix
      null_ls.builtins.formatting.fixjson, -- example for Nix JSON files
    }

    -- Setup null-ls
    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        -- Optional: format on save
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = 0, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })
  end,
}
