local term = require('toggleterm')

term.setup({
  size = 60,
  open_mapping = [[<c-\>]],
  -- direction = 'vertical',
  direction = 'float',
  -- shade_terminals = true,
  -- shading_factor = 2,
  float_opts = {
    border = 'curved',
    width = 180,
  },
})
