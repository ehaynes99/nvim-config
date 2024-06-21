local M = {}

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
  local root_files = {
    'package.json',
    'Cargo.toml',
    'Gemfile',
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
  }

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

M.package_manager = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  local lockfiles = {
    'package-lock.json',
    'yarn.lock',
    'pnpm-lock.yaml',
  }
  local lockfile = vim.fs.find(lockfiles, {
    path = path,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]

  if lockfile then
    local name = vim.fs.basename(lockfile)
    if name == 'package-lock.json' then
      return 'npm'
    elseif name == 'yarn.lock' then
      return 'yarn'
    elseif name == 'pnpm-lock.yaml' then
      return 'pnpm'
    else
    end
  end
  error('unknown lockfile type: ' .. vim.inspect(lockfile))
end

M.is_module = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  local package_file = vim.fs.find('package.json', {
    path = path,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]

  if package_file then
    local content = vim.fn.json_decode(vim.fn.readfile(package_file))
    return content.type == 'module'
  end
  error('could not find package.json: ' .. path)
end

return M
