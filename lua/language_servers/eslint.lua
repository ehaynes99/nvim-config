local keymaps = require('keymaps')

return {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    keymaps.lsp_keymaps(bufnr, function()
      vim.lsp.buf.format()
    end)
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
    -- experimental = {
    --   useFlatConfig = false,
    -- },
    onIgnoredFiles = 'off',
    -- packageManager = 'npm',
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
