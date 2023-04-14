local editor_utils = require('utils.editor')
local keymaps = require('keymaps')

local create_autoclose = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'NvimTree' },
    callback = function(args)
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            vim.api.nvim_buf_delete(args.buf, { force = true })
          end
          return true
        end,
      })
    end,
  })
end

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
  'nvim-tree/nvim-tree.lua',
  keys = {
    { '<leader>e', ':NvimTreeFocus<CR>', desc = 'Focus tree view' },
  },
  config = function()
    create_autoclose()

    require('nvim-tree').setup({
      view = {
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              style = 'minimal',
              -- border = 'none',
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      -- open_on_setup = true,
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
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      renderer = {
        icons = {
          glyphs = {
            git = {
              untracked = 'U',

              -- unstaged = '',
              -- staged = 'S',
              -- unmerged = '',
              -- renamed = '➜',
              -- untracked = 'U',
              -- deleted = '',
              -- ignored = '◌',
            },
          },
        },
        highlight_git = true,
      },
      actions = {
        change_dir = {
          restrict_above_cwd = true,
        },
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
    })

    keymaps.add({
      { '<leader>fw', editor_utils.search_tree_dir, { desc = 'Find: text within tree dir' } },
    })
  end,
}
