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
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- from 'windwp/nvim-ts-autotag' plugin
      autotag = {
        enable = true,
      },

      -- from 'RRethy/nvim-treesitter-endwise' plugin
      endwise = {
        enable = true,
      },
      disable = function(_, buf)
        local has_prop, value = pcall(vim.api.nvim_buf_get_var(buf, 'large_buf'))
        return has_prop and value
      end,
      playground = {
        enable = true,
      },
    })
  end,
}
