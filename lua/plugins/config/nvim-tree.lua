local nvim_tree = require('nvim-tree')
-- if needed to implement custom keymappings
-- local tree_cb = require('nvim-tree.config').nvim_tree_callback

nvim_tree.setup({
  view = {
    width = 40,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  open_on_setup = true,
  open_on_setup_file = true,
  create_in_closed_folder = true,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  renderer = {
    icons = {
      glyphs = {
        git = {
          untracked = 'U',
        },
      },
    },
  },
  actions = {
    change_dir = {
      restrict_above_cwd = true,
    },
  },
})
