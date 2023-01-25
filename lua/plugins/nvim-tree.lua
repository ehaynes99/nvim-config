return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup({
      view = {
        width = 40,
        hide_root_folder = true,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      open_on_setup = true,
      sync_root_with_cwd = true,
      -- open_on_setup_file = true,
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
      ---@diagnostic disable-next-line: unused-local
      on_attach = function(bufnr)
        -- buffer-specific keybinds
      end,
    })
  end,
}
