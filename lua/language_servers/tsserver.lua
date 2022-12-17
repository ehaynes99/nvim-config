local keymaps = require('keymaps')
local typescript = require('typescript')
local installer = require('language_servers.installer')

local actions = typescript.actions

return function()
  typescript.setup({
    server = {
      on_attach = function(_, bufnr)
        keymaps.lsp_keymaps(bufnr, installer.create_formatter(bufnr))

        keymaps.add({
          { 'gd', typescript.goToSourceDefinition, { desc = 'LSP: Goto definition', buffer = bufnr } },
          {
            '<leader>li',
            ':TypescriptGoToSourceDefinition<CR>',
            { desc = 'LSP: TypescriptAddMissingImports', buffer = bufnr },
          },
          {
            '<leader>lo',
            ':TypescriptOrganizeImports',
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
            -- some typescript djagnostics are invalid and/or are better
            -- handled by eslint. All message codes:
            -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            6133, -- unused variable - eslint will handle
            6138, -- unused property - eslint will handle
            80001, -- convert to ES module suggestion
          },
        },
      },
      init_options = {
        preferences = {
          importModuleSpecifierPreference = 'project-relative',
        },
      },
    },
  })
end
