local keymaps = require('keymaps')
local lsp_utils = require('plugins.config.lsp.lsp_utils')

return {
  on_attach = function(_, bufnr)
    keymaps.lsp_keymaps(bufnr, lsp_utils.create_formatter(bufnr))
  end,
  capabilities = lsp_utils.default_capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.inspect(vim.api.nvim_list_runtime_paths()),
      },

      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          [vim.fn.stdpath('config') .. '/lua'] = true,
        },
        checkThirdParty = false,
      },
      completion = {
        showWord = 'Disable',
      },
    },
  },
}
