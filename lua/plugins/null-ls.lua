return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    local null_ls = require('null-ls')

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
    local code_actions = null_ls.builtins.code_actions

    null_ls.setup({
      debug = false,
      sources = {
        -- lua
        formatting.stylua,

        -- python
        formatting.black,
        diagnostics.flake8,

        -- TypeScript/JavaScript
        formatting.prettier,
        diagnostics.eslint_d,
        code_actions.eslint_d,

        -- shell scripts
        diagnostics.shellcheck.with({ extra_args = { '-s', 'bash' } }),
        code_actions.shellcheck.with({ extra_args = { '-s', 'bash' } }),
        formatting.shfmt.with({ extra_args = { '--case-indent' } }),
        formatting.shellharden,
      },
      border = 'rounded',
    })
  end,
}
