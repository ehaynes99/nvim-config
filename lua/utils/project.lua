local M = {}

local root_files = {
  'package.json',
  'Cargo.toml',
  'Gemfile',
  'pom.xml',
  'build.gradle',
  'build.gradle.kts',
}

M.git_root = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  local root = vim.fs.find('.git', {
    path = path,
    upward = true,
    type = 'directory',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
  if root then
    return vim.fs.dirname(root)
  end
end

M.project_root = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  local root_file = vim.fs.find(root_files, {
    path = path,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
  if root_file then
    return vim.fs.dirname(root_file)
  end
end
return M
