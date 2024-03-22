return function()
  local keymaps = require('keymaps')
  local typescript = require('typescript')
  local installer = require('language_servers.installer')

  typescript.setup({
    server = {
      on_attach = function(client, bufnr)
        -- no formatter, uses eslint instead
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        keymaps.lsp_keymaps(bufnr)

        keymaps.add({
          {
            'gs',
            ':TypescriptGoToSourceDefinition<CR>',
            desc = 'LSP: TypeScript Goto source definition',
            buffer = bufnr,
          },
          {
            '<leader>li',
            ':TypescriptAddMissingImports<CR>',
            desc = 'LSP: TypeScript add missing imports',
            buffer = bufnr,
          },
          { '<leader>lR', ':TypescriptRenameFile<CR>', desc = 'LSP: TypeScript rename file', buffer = bufnr },
          -- {
          --   '<leader>lo',
          --   ':TypescriptOrganizeImports<CR>',
          --   desc = 'LSP: TypeScript organize imports',
          --   buffer = bufnr,
          -- },
          -- { '<leader>lu', ':TypescriptRemoveUnused<CR>', desc = 'LSP: TypeScript remove unused', buffer = bufnr },
          -- { '<leader>lF', ':TypescriptFixAll<CR>', desc = 'LSP: TypeScript fix all', buffer = bufnr },
        })
      end,
      capabilities = installer.default_capabilities(),
      settings = {
        diagnostics = {
          ignoredCodes = {
            -- Disable annoying diagnostics. All message codes:
            -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            6133, -- unused variable - eslint will handle
            6138, -- unused property - eslint will handle
            80001, -- convert to ES module suggestion
            80005, -- 'require' call may be converted to an import
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
