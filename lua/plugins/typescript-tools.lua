return {
  'pmizio/typescript-tools.nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    local keymaps = require('keymaps')
    local ts_tools = require('typescript-tools')
    local api = require('typescript-tools.api')
    local util = require('lspconfig.util')

    ts_tools.setup({
      root_dir = function(bufnr, onDir)
        return onDir(util.root_pattern('.git')(bufnr))
      end,
      settings = {
        publish_diagnostic_on = 'insert_leave',
        tsserver_max_memory = 8192,
        tsserver_file_preferences = {
          importModuleSpecifierPreference = 'project-relative',
          includeCompletionsWithSnippetText = true,
          includeCompletionsForImportStatements = true,
          preferTGoToSourceDefinition = true,
        },
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        keymaps.lsp_keymaps(bufnr) -- no formatter, uses eslint instead

        vim.keymap.set(
          'n',
          '<leader>li',
          ':TSToolsAddMissingImports<CR>',
          { desc = 'LSP: TSToolsAddMissingImports', buffer = bufnr }
        )
        vim.keymap.set(
          'n',
          '<leader>lR',
          ':TSToolsRenameFile<CR>',
          { desc = 'LSP: TypescriptRenameFile', buffer = bufnr }
        )
        vim.keymap.set(
          'n',
          'gs',
          ':TSToolsGoToSourceDefinition<CR>',
          { desc = 'LSP: TSToolsGoToSourceDefinition', buffer = bufnr }
        )
        -- hydrate_pnpm_monorepo()
      end,
      handlers = {
        -- Disable annoying diagnostics. All message codes:
        -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        ['textDocument/publishDiagnostics'] = api.filter_diagnostics({
          6133, -- unused variable - eslint will handle
          -- 6138, -- unused property - eslint will handle
          6192, -- unused imports - eslint will handle
          80001, -- convert to ES module suggestion
          80005, -- 'require' call may be converted to an import
          80006, -- may be converted to an async function -- auto-"fix" BREAKS CODE with multiple returns
          80007, -- unnecessary await - eslint will handle
        }),
      },
    })
  end,
}
