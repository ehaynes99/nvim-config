return {
  'kyazdani42/nvim-tree.lua',
  commit = '7282f7de8aedf861fe0162a559fc2b214383c51c',
  config = function()
    local nvim_tree = require('nvim-tree')
    local nvim_tree_config = require('nvim-tree.config')

    local tree_cb = nvim_tree_config.nvim_tree_callback

    nvim_tree.setup({
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      open_on_setup = true,
      open_on_setup_file = true,
      create_in_closed_folder = true,
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = '',
          info = '',
          warning = '',
          error = '',
        },
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
  end,
}
