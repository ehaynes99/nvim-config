local keymaps = require('keymaps')
local typescript = require('typescript')
local installer = require('language_servers.installer')

return function()
  typescript.setup({
    server = {
      on_attach = function(_, bufnr)
        keymaps.lsp_keymaps(bufnr) -- no formatter, uses eslint instead

        keymaps.add({
          -- { 'gd', ':TypescriptGoToSourceDefinition<CR>', { desc = 'LSP: Goto definition', buffer = bufnr } },
          {
            '<leader>li',
            ':TypescriptAddMissingImports<CR>',
            { desc = 'LSP: TypescriptAddMissingImports', buffer = bufnr },
          },
          {
            '<leader>lo',
            ':TypescriptOrganizeImports<CR>',
            { desc = 'LSP: TypescriptOrganizeImports', buffer = bufnr },
          },
          { '<leader>lu', ':TypescriptRemoveUnused<CR>', { desc = 'LSP: TypescriptRemoveUnused', buffer = bufnr } },
          { '<leader>lF', ':TypescriptFixAll<CR>', { desc = 'LSP: TypescriptFixAll', buffer = bufnr } },
          { '<leader>lR', ':TypescriptRenameFile<CR>', { desc = 'LSP: TypescriptRenameFile', buffer = bufnr } },
        })
      end,
      capabilities = installer.default_capabilities,
      settings = {
        diagnostics = {
          ignoredCodes = {
            -- Disable annoying diagnostics. All message codes:
            -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            6133, -- unused variable - eslint will handle
            6138, -- unused property - eslint will handle
            80001, -- convert to ES module suggestion
            80006, -- may be converted to an async function -- auto-"fix" BREAKS CODE with multiple returns
          },
        },
        completions = {
          completeFunctionCalls = true,
        },
      },
      init_options = {
        preferences = {
          importModuleSpecifierPreference = 'project-relative',
          includeCompletionsWithSnippetText = true,
          includeCompletionsForImportStatements = true,
        },
      },
    },
  })
end
