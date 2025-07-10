return {
  'mason-org/mason-lspconfig.nvim',
  config = true,
  opts = {
    automatic_enable = {
      exclude = {
        'rust_analyzer',
        'ts_ls',
        'eslint',
      },
    },
    ensure_installed = {
      'bashls',
      'cssls',
      'html',
      'jsonls',
      'lua_ls',
      'pyright',
      'sqlls',
      'graphql',
      -- managed by typescript-tools
      -- 'ts_ls',
      -- managed by nvim-eslint
      -- 'eslint',
    },
  },
  dependencies = {
    'neovim/nvim-lspconfig',
    {
      'mason-org/mason.nvim',
      config = true,
      opts = {
        ensure_installed = {
          -- Formatters and linters (not LSP servers)
          'sqlfluff',
          'stylua',
          'black',
          'shfmt',
          'shellharden',
        },
        ui = {
          border = 'rounded',
        },
      },
    },
  },
}
