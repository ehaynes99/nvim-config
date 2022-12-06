local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    prompt_prefix = ' ',
    selection_caret = ' ',
    file_ignore_patterns = {
      '.git/',
      'node_modules',
      'package-lock.json',
    },

    mappings = {
      i = {
        ['<Down>'] = actions.cycle_history_next,
        ['<Up>'] = actions.cycle_history_prev,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
})

telescope.load_extension('fzf')
