require('constants')
require('options')
require('autocommands')
require('filetypes')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('keymaps').init()
  end,
})

require('lazy_install')
