require('constants')
require('options')
require('autocommands')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('keymaps').init()
    require('commands')
  end,
})

require('lazy_install')
