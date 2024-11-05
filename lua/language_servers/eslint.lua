local keymaps = require('keymaps')

return {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    keymaps.lsp_keymaps(bufnr, function()
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end)
  end,

  -- https://github.com/Microsoft/vscode-eslint#settings-options
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
    onIgnoredFiles = 'off',
    problems = {
      shortenToSingleLine = false,
    },
    run = 'onType',
    validate = 'on',
    workingDirectory = {
      mode = 'location',
    },
    enable = true,
    format = true,
  },
}

