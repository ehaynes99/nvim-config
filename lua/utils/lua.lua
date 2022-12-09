local M = {}

M.curry = function(fn)
  return function(...)
    local args = { ... }
    return function()
      ---@diagnostic disable-next-line: deprecated
      fn(unpack(args))
    end
  end
end

return M
