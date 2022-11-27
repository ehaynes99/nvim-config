return {
  'nvim-lualine/lualine.nvim',
  commit = 'b6314ac556098d7abea9bb8cf896d2e3500eca41',
  after = { 'nvim-web-devicons' },
  config = function()
    local lualine = require('lualine')
    lualine.setup()
  end,
}
