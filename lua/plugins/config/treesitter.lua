-- odd choice of nesting, but this contains the setup function
local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
  ensure_installed = {
    -- 'javascript',
    -- 'typescript',
    -- 'rust',
    -- 'lua',
    -- 'markdown',
    -- 'markdown_inline',
    -- 'bash',
    -- 'python',
  },
  auto_install = true,
})
