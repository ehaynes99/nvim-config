local which_key = require('which-key')
local editor_utils = require('utils.editor')

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
    w = { editor_utils.search_tree_dir, 'Within tree dir' },
  },
  ['<leader>l'] = {
    name = 'LSP',
  },
  ['<leader>w'] = {
    name = 'Window',
    h = { editor_utils.close_hidden_buffers, 'Close all hidden buffer' },
  },
  ["<leader>'"] = {
    name = 'Tmp',
    s = { '<cmd>:source %<CR>', 'Source current file' },
    x = { '<cmd>:LuaRun<CR>', 'Run current file' },
  },
})
