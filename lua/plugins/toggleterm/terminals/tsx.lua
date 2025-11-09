local project_utils = require('utils.project')

return function(Terminal)
  local term = Terminal:new({
    direction = 'vertical',
    close_on_exit = true,
    hidden = true,
  })

  local execute = function()
    local file = vim.api.nvim_buf_get_name(0)
    local project_root = project_utils.project_root(file)

    if not project_root then
      vim.notify('could not find project root: ' .. file, vim.log.levels.ERROR)
      return
    end

    local cmd = 'pnpx tsx watch ' .. file

    if term:is_open() then
      term:change_dir(project_root)
    else
      term.dir = project_root
    end
    term.cmd = cmd
    term:toggle()
  end

  return { execute = execute }
end
