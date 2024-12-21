return {
  'ehaynes99/nvim-eslint',
  -- dir = '/home/erich/workspace/ehaynes99/nvim-eslint',
  config = function()
    local nvim = require('nvim-eslint')
    nvim.setup({
      settings = {
        format = true,
        codeActionOnSave = {
          enable = false,
          mode = 'all',
        },
      },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true

        local format = function()
          vim.lsp.buf.format({ timeout_ms = 2000 })
        end
        vim.keymap.set('n', 'ff', format, { silent = true, buffer = bufnr, desc = 'LSP: Format document' })
        
        require('keymaps').lsp_keymaps(bufnr, function()
          print('formatting with eslint')
          vim.lsp.buf.format({ timeout_ms = 2000 })
        end)
      end,
    })
  end,
}
