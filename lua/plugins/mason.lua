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
        -- Crashdummyy's registry ships a more up-to-date `roslyn` package
        -- (matching VS Code's version) than the one on nuget.org in the
        -- core registry.
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry',
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
          -- managed by roslyn.nvim, not mason-lspconfig
          'roslyn',
        },
      },
    },
  },
}
