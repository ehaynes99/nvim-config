local bufferline = require('bufferline')

bufferline.setup({
  options = {
    close_command = 'BDelete %d',
    offsets = { { filetype = 'NvimTree', text = '', padding = 1 } },
    separator_style = 'thin',
  },
})
