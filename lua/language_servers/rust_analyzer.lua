return function()
  local rt = require('rust-tools')
  local keymaps = require('keymaps')
  rt.setup({
    tools = {
      inlay_hints = {
        auto = true,
        only_current_line = false,
        show_parameter_hints = true,
      },
    },
    server = {
      on_attach = function(_, bufnr)
        local formatter =  require('language_servers.installer').create_formatter(bufnr)
        keymaps.lsp_keymaps(bufnr, formatter)
      end,
    },
  })
end
