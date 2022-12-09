local null_ls = require('null-ls')
local null_ls_sources = require('null-ls.sources')

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  sources = {
    formatting.prettier,
    formatting.black.with({ extra_args = { '--fast' } }),
    formatting.stylua,
    -- formatting.google_java_format,
    diagnostics.flake8,
    diagnostics.eslint,
  },
})
