return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    local keymaps = require('keymaps')
    local ts_tools = require('typescript-tools')
    local api = require('typescript-tools.api')

    ts_tools.setup({
      settings = {
        publish_diagnostic_on = 'change',
        expose_as_code_action = {
          'add_missing_imports',
        },
      },
      on_attach = function(_, bufnr)
        keymaps.lsp_keymaps(bufnr) -- no formatter, uses eslint instead

        keymaps.add({
          {
            '<leader>li',
            ':TSToolsAddMissingImports<CR>',
            desc = 'LSP: TSToolsAddMissingImports',
            buffer = bufnr,
          },
          { '<leader>lR', ':TSToolsRenameFile<CR>', desc = 'LSP: TypescriptRenameFile', buffer = bufnr },
          { 'gs', ':TSToolsGoToSourceDefinition<CR>', desc = 'LSP: TSToolsGoToSourceDefinition' },
        })
      end,
      handlers = {
        ['textDocument/publishDiagnostics'] = api.filter_diagnostics({
          6133, -- unused variable - eslint will handle
          6138, -- unused property - eslint will handle
          80001, -- convert to ES module suggestion
          80005, -- 'require' call may be converted to an import
          80006, -- may be converted to an async function -- auto-"fix" BREAKS CODE with multiple returns
        }),
      },
    })
  end,
}
