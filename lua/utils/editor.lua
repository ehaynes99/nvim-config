local M = {}

-- close any non-visible buffers
M.close_hidden_buffers = function()
  local close_buffers = require('close_buffers')
  close_buffers.delete({ type = 'hidden', force = true })
end

-- telescope live grep within folder selected in nvim-tree
M.search_tree_dir = function()
  local api = require('nvim-tree.api')
  local utils = require('nvim-tree.utils')

  if utils.is_nvim_tree_buf(0) then
    local node = api.tree.get_node_under_cursor()
    for k, _ in pairs(node) do
      print(k)
    end
    local path = node.absolute_path
    if vim.fn.isdirectory(path) == 1 then
      local telescope = require('telescope.builtin')
      telescope.live_grep({ cwd = path })
    end
  end
end

return M
