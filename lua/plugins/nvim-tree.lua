local editor_utils = require('utils.editor')

-- local HEIGHT_RATIO = 0.8
-- local WIDTH_RATIO = 0.5

return {
  'nvim-tree/nvim-tree.lua',
  keys = {
    {
      '<leader>e',
      function()
        local api = require('nvim-tree.api')
        if api.tree.is_tree_buf(0) then
          api.tree.close()
        elseif api.tree.is_visible() then
          api.tree.focus()
        else
          api.tree.open()
        end
      end,
      desc = 'Toggle tree view',
    },
    { '<leader>fw', editor_utils.search_tree_dir, desc = 'Find: text within tree dir' },
  },
  config = function()
    require('nvim-tree').setup({
      actions = {
        change_dir = {
          restrict_above_cwd = true,
        },
        open_file = {
          quit_on_open = true,
          window_picker = {
            enable = false,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      notify = {
        threshold = vim.log.levels.WARN,
      },
      sync_root_with_cwd = true,
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
        ignore = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
        timeout = 1500,
      },
      renderer = {
        root_folder_label = false,
        icons = {
          glyphs = {
            git = {
              untracked = '+',
              staged = 'M',
              unstaged = 'M',
              renamed = '➜',
              deleted = '',
              ignored = '',
              unmerged = '',
            },
          },
        },
        highlight_git = true,
      },
      view = {
        width = 40,
        -- float = {
        --   enable = true,
        --   quit_on_focus_loss = true,
        --   open_win_config = function()
        --     local screen_w = vim.opt.columns:get()
        --     local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        --     local window_w = screen_w * WIDTH_RATIO
        --     local window_h = screen_h * HEIGHT_RATIO
        --     local window_w_int = math.floor(window_w)
        --     local window_h_int = math.floor(window_h)
        --     local center_x = (screen_w - window_w) / 2
        --     local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
        --     return {
        --       style = 'minimal',
        --       border = 'rounded',
        --       relative = 'editor',
        --       row = center_y,
        --       col = center_x,
        --       width = window_w_int,
        --       height = window_h_int,
        --     }
        --   end,
        -- },
        -- width = function()
        --   return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        -- end,
      },
    })
  end,
}
