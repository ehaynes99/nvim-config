local keymaps = require('keymaps')
local installer = require('language_servers.installer')

return {
  on_attach = function(_, bufnr)
    -- client.server_capabilities.document_formatting = true
    keymaps.lsp_keymaps(bufnr, '<cmd>:EslintFixAll<CR>')
  end,
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
      showDocumentation = {
        enable = true,
      },
    },
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    experimental = {
      useFlatConfig = false,
    },
    onIgnoredFiles = 'off',
    packageManager = 'npm',
    problems = {
      shortenToSingleLine = false,
    },
    quiet = false,
    run = 'onType',
    useESLintClass = false,
    validate = 'on',
    workingDirectory = {
      mode = 'location',
    },
    enable = true,
    format = true,
    autoFixOnSave = false,
  },
}
