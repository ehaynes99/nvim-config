return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-telescope/telescope-live-grep-args.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local lga_actions = require('telescope-live-grep-args.actions')

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
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ['<C-u>'] = lga_actions.quote_prompt(),
              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        },
      },
    })

    telescope.load_extension('fzf')
  end,
}
