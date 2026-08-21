return {
  'mason-org/mason-lspconfig.nvim',
  config = true,
  opts = {
    automatic_enable = {
      exclude = {
        'rust_analyzer',
        'ts_ls',
        -- 'tsgo',
        'eslint',
      },
    },
    ensure_installed = {
      'bashls',
      'biome',
      'cssls',
      'html',
      'jsonls',
      'lua_ls',
      'oxfmt',
      'oxlint',
      'pyright',
      'sqlls',
      'graphql',
      'tsgo',
      'rust_analyzer',
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
        ui = {
          border = 'rounded',
        },
      },
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      dependencies = { 'mason-org/mason.nvim' },
      opts = {
        ensure_installed = {
          -- Formatters and linters (not LSP servers)
          'sqlfluff',
          'stylua',
          'black',
          'shfmt',
          'shellharden',
          'tree-sitter-cli',
        },
      },
    },
  },
}
