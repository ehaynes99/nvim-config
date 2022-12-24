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
  return vim.fs.find('.git', {
    path = path,
    upward = true,
    type = 'directory',
  })[1]
end

M.project_root = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  return vim.fs.find(root_files, {
    path = path,
    upward = true,
    type = 'file',
  })[1]
end

return M
