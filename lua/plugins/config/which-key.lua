local which_key = require('which-key')

which_key.setup({
  plugins = {
    presets = {
      operators = true,
    },
  },
})

which_key.register({
  ['<leader>f'] = {
    name = 'Find',
    f = { ':Telescope find_files<CR>', 'Files' },
    t = { ':Telescope live_grep<CR>', 'Text' },
    -- p = { ':Telescope projects<CR>', 'Projects' },
    b = { ':Telescope buffers<CR>', 'Buffers' },
  },
  ['<leader>l'] = {
    name = 'LSP',
  },
  ["<leader>'"] = {
    name = 'Tmp',
    s = { '<cmd>:source %<CR>', 'Source current file' },
    x = {
      function()
        require('utils.editor').close_others()
      end,
      'test!',
    },
  },
})
