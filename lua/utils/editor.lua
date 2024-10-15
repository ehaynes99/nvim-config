local M = {}

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

M.is_file = function(bufnr)
  return vim.bo[bufnr].buflisted and vim.api.nvim_buf_get_name(bufnr) ~= ''
end

M.all_buffers = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    print(vim.inspect(M.buf_get_options(buf)))
  end
end

M.file_buffers = function()
  local all_buffers = vim.api.nvim_list_bufs()
  return vim.tbl_filter(M.is_file, all_buffers)
end

M.buffers_in_directory = function(path)
  return vim.tbl_filter(function(buf)
    local buf_path = vim.api.nvim_buf_get_name(buf)
    return buf_path:sub(1, #path) == path
  end, M.file_buffers())
end

M.buffers_not_in_directory = function(path)
  return vim.tbl_filter(function(buf)
    local buf_path = vim.api.nvim_buf_get_name(buf)
    return buf_path:sub(1, #path) ~= path
  end, M.file_buffers())
end

-- see `:h options` section '3. Options summary'
M.buf_get_options = function(bufnr, option_names)
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

  option_names = option_names or all_buffer_opts
  local result = {
    id = bufnr,
    name = vim.api.nvim_buf_get_name(bufnr),
  }
  for _, option in ipairs(option_names) do
    result[option] = vim.api.nvim_get_option_value(option, { buf = bufnr })
  end
  return result
end

M.close_hidden_buffers = function()
  local close_buffers = require('close_buffers')
  close_buffers.delete({ type = 'hidden', force = true })
  vim.cmd('redraw!')
end

M.close_all_buffers = function()
  local close_buffers = require('close_buffers')
  close_buffers.delete({ type = 'all', force = true })
  vim.cmd('redraw!')
end

M.close_buffers_not_in_project = function()
  local project = require('utils.project')
  local close_buffers = require('close_buffers')

  local project_root = project.project_root()
  local buffers_to_close = M.buffers_not_in_directory(project_root)
  for _, buf in ipairs(buffers_to_close) do
    close_buffers.delete({ type = buf, force = true })
  end
end

return M
