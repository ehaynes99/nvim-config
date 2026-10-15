local M = {}

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

-- Mirrors `dit rev-parse --verify --quiet HEAD:<path>` (see ~/.config/bash/dotfiles.sh).
-- Returns { git_dir, work_tree } when dir is tracked in the bare dotfiles repo, else nil.
M.repo_for = function(dir)
  local home = vim.fn.expand('$HOME')
  local relpath = relative_to_home(dir, home)
  if relpath == nil then
    return nil
  end

  local git_dir = home .. '/.dotfiles.git'
  local ref = relpath == '' and 'HEAD' or ('HEAD:' .. relpath)
  vim.fn.system({ 'git', '--git-dir', git_dir, 'rev-parse', '--verify', '--quiet', ref })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return { git_dir = git_dir, work_tree = home }
end

return M
