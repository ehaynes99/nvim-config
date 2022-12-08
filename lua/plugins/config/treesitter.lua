-- odd choice of nesting, but this contains the setup function
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
    additional_vim_regex_highlighting = true,
  },

  -- from 'windwp/nvim-ts-autotag' plugin
  autotag = {
    enable = true,
  },

  -- from 'RRethy/nvim-treesitter-endwise' plugin
  endwise = {
    enable = true,
  },
})
