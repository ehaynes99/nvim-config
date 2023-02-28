local editor_utils = require('utils.editor')
local keymaps = require('keymaps')

local create_autoclose = function()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'NvimTree' },
    callback = function(args)
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          vim.api.nvim_buf_delete(args.buf, { force = true })
          return true
        end,
      })
    end,
  })
end

return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    create_autoclose()

    require('nvim-tree').setup({
      view = {
        width = 40,
        hide_root_folder = true,
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
            },
          },
        },
        highlight_git = true,
      },
      actions = {
        change_dir = {
          restrict_above_cwd = true,
        },
      },
    })

    keymaps.add({
      { '<leader>e', ':NvimTreeFocus<CR>', { desc = 'Focus tree view' } },
      { '<leader>E', ':NvimTreeToggle<CR>', { desc = 'Open tree view' } },
      { '<leader>fw', editor_utils.search_tree_dir, { desc = 'Find: text within tree dir' } },
    })
  end,
}
