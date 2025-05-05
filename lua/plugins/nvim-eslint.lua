return {
  -- 'esmuellert/nvim-eslint',
  -- 'ehaynes99/nvim-eslint',
  dir = '/home/erich/workspace/ehaynes99/nvim-eslint',
  config = function()
    local nvim = require('nvim-eslint')
    nvim.setup({
      filetypes = { 'yaml' },
      settings = {
        format = true,
        useFlatConfig = true,
        codeActionOnSave = {
          enable = false,
          mode = 'all',
        },
        onIgnoredFiles = 'off',
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true

        require('keymaps').lsp_keymaps(bufnr, function()
          print('formatting with eslint')
          vim.lsp.buf.format({ timeout_ms = 5000 })
        end)
      end,
    })
  end,
}
