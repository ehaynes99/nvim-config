local project_utils = require('utils.project')
local terminal_utils = require('plugins.toggleterm.terminals.terminal_utils')

return function(Terminal)
  local term = Terminal:new({
    direction = 'vertical',
    -- close_on_exit = false,
    hidden = true,
    on_exit = terminal_utils.close_if_successful,
  })

  local run = function()
    local test_file = vim.api.nvim_buf_get_name(0)
    local project_root = project_utils.project_root(test_file)

    if not project_root then
      print('could not find project root: ' .. test_file)
      return
    end

    local cmd = 'pnpx vitest run --project default --watch --disableConsoleIntercept ' .. test_file

    print('project root: ' .. project_root)
    print('test file: ' .. test_file)
    print('cmd: ' .. cmd)

    if term:is_open() then
      term:change_dir(project_root)
    else
      term.dir = project_root
    end
    term.cmd = cmd
    term:toggle()
  end

  return { run = run }
end
