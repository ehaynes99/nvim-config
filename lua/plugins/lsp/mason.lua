local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local installer = require('language_servers.installer')

mason.setup({
  ui = {
    border = 'rounded',
  },
})

mason_lsp.setup({
  ensure_installed = {
    'cssls',
    'html',
    'pyright',
    'bashls',
    'jsonls',
    'rust_analyzer',
    'sumneko_lua',
    'tsserver',
  },
  automatic_installation = true,
})

mason_lsp.setup_handlers({ installer.configure_server })
