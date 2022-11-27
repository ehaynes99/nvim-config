local M = {}

function M.is_buffer_dirty(buf)
  buf = buf or 0
  return vim.fn.getbufinfo(buf)[1].changed ~= 0
end

return M
