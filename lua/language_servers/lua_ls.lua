return {
  -- before_init = require('neodev.lsp').before_init,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.inspect(vim.api.nvim_list_runtime_paths()),
      },
      diagnostics = {
        globals = { 'vim', 'awesome', 'client', 'screen', 'root' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      completion = {
        showWord = 'Disable',
      },
    },
  },
}
