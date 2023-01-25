local mason_config = function()
  require('neodev').setup()
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
end

local native_lsp_config = function()
  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  require('lspconfig.ui.windows').default_options.border = 'rounded'

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saadparwaiz1/cmp_luasnip',
    'williamboman/mason.nvim',
    'folke/neodev.nvim',
    'williamboman/mason-lspconfig.nvim',
    'simrat39/rust-tools.nvim',
    'folke/trouble.nvim',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/typescript.nvim',
    'Saecki/crates.nvim',
  },
  config = function()
    native_lsp_config()
    mason_config()
  end,
}
