return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
  },
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter.configs')

    treesitter.setup({
      ensure_installed = {
        'javascript',
        'typescript',
        'tsx',
        'rust',
        'lua',
        'markdown',
        'markdown_inline',
        'bash',
        'python',
        'sql',
        'vim',
        'vimdoc',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          scope_incremental = '<C-space>',
          node_incremental = '<TAB>',
          node_decremental = '<S-TAB>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
      indent = {
        enable = true,
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, bufnr)
          return vim.b[bufnr].large_buf or false
        end,
      },

      -- from 'windwp/nvim-ts-autotag' plugin
      autotag = {
        enable = true,
      },

      -- from 'RRethy/nvim-treesitter-endwise' plugin
      endwise = {
        enable = true,
      },
      playground = {
        enable = true,
      },
    })
  end,
}
