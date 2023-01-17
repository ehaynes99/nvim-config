require('constants')
require('options')
if os.getenv('LAZY') == 'false' then
  require('packer_install')
  require('keymaps')
  require('commands')
  require('autocommands')
else
  require('lazy_install')
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      require('keymaps')
      require('commands')
      require('autocommands')
    end,
  })
end
