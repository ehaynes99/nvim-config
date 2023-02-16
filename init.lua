require('constants')
require('options')
require('autocommands')
require('lazy_install')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('keymaps')
    require('commands')
  end,
})
