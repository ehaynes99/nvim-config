local M = {}

M.git_root = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  for dir in vim.fs.parents(path) do
    local check_dir = dir .. '/.git'
    if vim.fn.isdirectory(check_dir) == 1 then
      return dir
    end
  end
  return vim.fn.getcwd()
end

M.current_dir = function()
  -- regular files have empty string for buftype
  local is_file = vim.api.nvim_buf_get_option(0, 'buftype') == ''
  if is_file then
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fs.dirname(filename)
  else
  end
end

return M
