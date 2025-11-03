local project_utils = require('utils.project')
local terminal_utils = require('plugins.toggleterm.terminals.terminal_utils')

return function(Terminal)
  local term = Terminal:new({
    hidden = true,
    close_on_exit = false,
    float_opts = {
      border = 'rounded',
    },
    on_exit = terminal_utils.close_if_successful,
    on_open = function(t)
      vim.keymap.set('t', '<ESC>', '<ESC>', { buffer = t.bufnr, nowait = true })
    end,
  })

  local toggle = function()
    local git_root = project_utils.git_root() or vim.fn.getcwd()
    term.cmd = 'gitui -d ' .. git_root
    term:toggle()
  end

  return { toggle = toggle }
end