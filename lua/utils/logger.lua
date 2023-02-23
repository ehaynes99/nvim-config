local LOG_FILE = vim.fn.stdpath('cache') .. '/nvim-erich.log'

local M = {
  level = os.getenv('NVIM_LOG_LEVEL') or 'info',
}

local levels = {
  trace = 0,
  debug = 1,
  info = 2,
  warn = 3,
  error = 4,
}

local join = function(...)
  local parts = { n = select('#', ...), ... }
  local strings = {}
  for i = 1, parts.n do
    table.insert(strings, vim.inspect(parts[i]))
  end
  return table.concat(strings, ' ')
end

local make_method = function(level)
  return function(...)
    if levels[level] < levels[M.level] then
      return
    end
    local msg = join({ ... })

    local str = string.format(
      '[%s %-6s] %s\n',
      os.date('!%Y-%m-%dT%H:%M:%SZ'),
      level:upper(),
      msg
    )

    local file = io.open(LOG_FILE, 'a')
    ---@diagnostic disable-next-line: need-check-nil
    file:write(str)
    ---@diagnostic disable-next-line: need-check-nil
    file:close()
  end
end

M.trace = make_method('trace')
M.debug = make_method('debug')
M.info = make_method('info')
M.warn = make_method('warn')
M.error = make_method('error')

return M
