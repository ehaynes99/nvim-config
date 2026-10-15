local dotfiles = require('utils.dotfiles')
local project_utils = require('utils.project')
local terminal_utils = require('plugins.toggleterm.terminals.terminal_utils')

return function(Terminal)
  local term = Terminal:new({
    hidden = true,
    close_on_exit = false,
    env = {
      GIT_EDITOR = vim.fn.stdpath('config') .. '/scripts/gitui-edit',
    },
    float_opts = {
      border = 'rounded',
    },
    on_exit = terminal_utils.close_if_successful,
    on_open = function(t)
      vim.keymap.set('t', '<ESC>', '<ESC>', { buffer = t.bufnr, nowait = true })
    end,
  })

  -- Called over RPC by scripts/gitui-edit. gitui blocks until the editor exits,
  -- so return immediately and do the work once it has redrawn.
  _G.GituiEdit = function(path)
    vim.schedule(function()
      term:close()
      vim.cmd('stopinsert')
      vim.cmd.edit(vim.fn.fnameescape(path))
    end)
    return 0
  end

  local toggle = function()
    local project_dir = project_utils.git_root() or vim.fn.getcwd()
    local repo = dotfiles.repo_for(project_dir)

    if repo then
      term.cmd = 'gitui -d ' .. repo.git_dir .. ' -w ' .. repo.work_tree
    else
      term.cmd = 'gitui -d ' .. project_dir
    end
    term:toggle()
  end

  return { toggle = toggle }
end
