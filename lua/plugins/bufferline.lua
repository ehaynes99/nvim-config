return {
  'akinsho/bufferline.nvim',
  commit = '4ecfa81e470a589e74adcde3d5bb1727dd407363',
  requires = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bufferline = require('bufferline')
    bufferline.setup({
      options = {
        close_command = 'w|bd %d',
        offsets = { { filetype = 'NvimTree', text = '', padding = 1 } },
        separator_style = 'thin',
      },
    })
  end,
}
