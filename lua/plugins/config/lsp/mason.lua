local keymaps = require('keymaps')
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local lsp_utils = require('plugins.config.lsp.lsp_utils')

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

mason_lsp.setup_handlers({
  function(server_name)
    local has_config, config = pcall(require, 'language_servers.' .. server_name)

    if not has_config then
      config = {
        on_attach = function(_, bufnr)
          keymaps.lsp_keymaps(bufnr, lsp_utils.create_formatter(bufnr))
        end,
        capabilities = lsp_utils.default_capabilities,
      }
    end
    if type(config) == 'function' then
      config()
    else
      lspconfig[server_name].setup(config)
    end
  end,
})
