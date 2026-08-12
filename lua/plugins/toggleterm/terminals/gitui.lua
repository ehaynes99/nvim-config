local project_utils = require('utils.project')
local terminal_utils = require('plugins.toggleterm.terminals.terminal_utils')

-- Returns path relative to home, '' if path is home, or nil if path isn't under home.
local function relative_to_home(path, home)
  if path == home then
    return ''
  end
  local prefix = home .. '/'
  if path:sub(1, #prefix) == prefix then
    return path:sub(#prefix + 1)
  end
  return nil
end

-- Mirrors `dit rev-parse --verify --quiet HEAD:<path>`, checking whether
-- project_dir is tracked in the bare dotfiles repo (see `dit`/`ditui` aliases).
local function is_dotfiles_tracked(project_dir, home)
  local relpath = relative_to_home(project_dir, home)
  if relpath == nil then
    return false
  end

  local ref = relpath == '' and 'HEAD' or ('HEAD:' .. relpath)
  vim.fn.system({ 'git', '--git-dir', home .. '/.dotfiles.git', 'rev-parse', '--verify', '--quiet', ref })
  return vim.v.shell_error == 0
end

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
    local project_dir = project_utils.git_root() or vim.fn.getcwd()
    local home = vim.fn.expand('$HOME')

    if is_dotfiles_tracked(project_dir, home) then
      term.cmd = 'gitui -d ' .. home .. '/.dotfiles.git/ -w ' .. home
    else
      term.cmd = 'gitui -d ' .. project_dir
    end
    term:toggle()
  end

  return { toggle = toggle }
end