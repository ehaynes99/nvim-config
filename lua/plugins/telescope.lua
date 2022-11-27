return {
  'nvim-telescope/telescope.nvim',
  commit = '76ea9a898d3307244dce3573392dcf2cc38f340f',
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {

        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = { 'smart' },
        file_ignore_patterns = { '.git/', 'node_modules' },

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
  end,
}
