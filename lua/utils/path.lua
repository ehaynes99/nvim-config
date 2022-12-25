local M = {}

M.is_file = function(path)
  local f = io.open(path, 'r')
  if f ~= nil then
    io.close(f)
    return true
  end
end

M.is_dir = function(path)
  return vim.fn.isdirectory(path) ~= 0
end

return M
