return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/playground',
  },
  config = function()
    local treesitter = require('nvim-treesitter.configs')

    treesitter.setup({
      ensure_installed = {
        'javascript',
        'typescript',
        'rust',
        'lua',
        'markdown',
        'markdown_inline',
        'bash',
        'python',
      },
      indent = {
        enabled = true,
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
