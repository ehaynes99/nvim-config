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
    local path = node.absolute_path
    if vim.fn.isdirectory(path) == 1 then
      local telescope = require('telescope.builtin')
      telescope.live_grep({ cwd = path })
    end
  end
end

-- TODO - ensure that this is accurate
M.buf_is_file = function(buf)
  buf = buf or 0

  return vim.api.nvim_buf_get_option(0, 'buftype') == ''
end

-- see `:h options` section '3. Options summary'
M.buf_get_options = function(buf, option_names)
  local result = {}
  for _, option in pairs(option_names) do
    result[option] = vim.api.nvim_buf_get_option(buf, option)
  end
  return result
end

-- adapted from: https://github.com/akinsho/bufferline.nvim/blob/4ecfa81e470a589e74adcde3d5bb1727dd407363/lua/bufferline/utils/init.lua#L132-L136
-- The provided api nvim_is_buf_loaded filters out all hidden buffers
function M.is_valid(buf_num)
  if not buf_num or buf_num < 1 then
    return false
  end
  local exists = vim.api.nvim_buf_is_valid(buf_num)
  return vim.bo[buf_num].buflisted and exists
end

-- adapted from: https://github.com/akinsho/bufferline.nvim/blob/4ecfa81e470a589e74adcde3d5bb1727dd407363/lua/bufferline/utils/init.lua#L143
M.get_valid_buffers = function()
  return vim.tbl_filter(M.is_valid, vim.api.nvim_list_bufs())
end

return M
