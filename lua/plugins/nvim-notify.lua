return {
  'rcarriga/nvim-notify',
  tag = 'v3.9.1',
  after = 'onedark.nvim',
  config = function()
    require('notify').setup({
      background_colour = '#000000',
    })
  end,
}
