return {
  'petertriho/nvim-scrollbar',
  enabled = false,
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    require('scrollbar').setup()
    require('gitsigns').setup()
    require('scrollbar.handlers.gitsigns').setup()
  end,
}
