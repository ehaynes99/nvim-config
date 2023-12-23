local M = {}

-- close any non-visible buffers
M.close_hidden_buffers = function()
  local close_buffers = require('close_buffers')
  close_buffers.delete({ type = 'hidden', force = true })
  vim.cmd('redraw!')
end

-- telescope live grep within folder selected in nvim-tree
M.search_tree_dir = function()
  local api = require('nvim-tree.api')
  local utils = require('nvim-tree.utils')

  if utils.is_nvim_tree_buf(0) then
    local node = api.tree.get_node_under_cursor()
    if node then
      local path = node.absolute_path
      if vim.fn.isdirectory(path) == 1 then
        local telescope = require('telescope.builtin')
        telescope.live_grep({ cwd = path })
      end
    end
  end
end

local all_buffer_opts = {
  'bufhidden',
  'buflisted',
  'buftype',
  'filetype',
  'modifiable',
  'modified',
  'readonly',
  'swapfile',
  'undofile',
}

M.all_buffers = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    print(vim.inspect(M.buf_get_options(buf)))
  end
end

M.buf_is_file = function(bufnr)
  bufnr = bufnr or 0

  return vim.api.nvim_get_option_value('buftype', { buf = 0 }) == ''
end

-- see `:h options` section '3. Options summary'
M.buf_get_options = function(bufnr, option_names)
  option_names = option_names or all_buffer_opts
  local result = {
    id = bufnr,
    name = vim.api.nvim_buf_get_name(bufnr),
  }
  for _, option in ipairs(option_names) do
    result[option] = vim.api.nvim_buf_get_option(bufnr, option)
  end
  return result
end

-- adapted from: https://github.com/akinsho/bufferline.nvim/blob/4ecfa81e470a589e74adcde3d5bb1727dd407363/lua/bufferline/utils/init.lua#L132-L136
-- The provided api nvim_is_buf_loaded filters out all hidden buffers
function M.is_valid(bufnr)
  if not bufnr or bufnr < 1 then
    return false
  end
  local exists = vim.api.nvim_buf_is_valid(bufnr)
  return vim.bo[bufnr].buflisted and exists
end

-- adapted from: https://github.com/akinsho/bufferline.nvim/blob/4ecfa81e470a589e74adcde3d5bb1727dd407363/lua/bufferline/utils/init.lua#L143
M.get_valid_buffers = function()
  return vim.tbl_filter(M.is_valid, vim.api.nvim_list_bufs())
end

return M
