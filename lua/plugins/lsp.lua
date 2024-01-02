local mason_config = function()
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
      'lua_ls',
      'tsserver',
      'eslint',
      'sqlls',
    },
    automatic_installation = true,
  })

  mason_lsp.setup_handlers({ installer.configure_server })
end

local native_lsp_config = function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      },
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
    'towolf/vim-helm',
    'saadparwaiz1/cmp_luasnip',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'simrat39/rust-tools.nvim',
    'folke/trouble.nvim',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/typescript.nvim',
  },
  config = function()
    native_lsp_config()
    mason_config()
  end,
}
