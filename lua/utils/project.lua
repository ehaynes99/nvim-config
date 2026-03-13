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

M.package_json = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  local package_file = vim.fs.find('package.json', {
    path = path,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
  if package_file then
    return vim.fn.json_decode(vim.fn.readfile(package_file))
  end
end

M.package_json_script_names = function(path)
  local package = M.package_json(path)
  if package then
    return vim.tbl_keys(package.scripts or {})
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

M.package_json_path = function(path)
  path = path or vim.api.nvim_buf_get_name(0)
  return vim.fs.find('package.json', {
    path = path,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
end

M.monorepo_root = function(path)
  local pkg_file = M.package_json_path(path)
  if not pkg_file then return nil end

  local pkg_dir = vim.fs.dirname(pkg_file)
  local parent = vim.fs.dirname(pkg_dir)
  if not parent or parent == pkg_dir then return nil end

  -- pnpm uses pnpm-workspace.yaml
  local pnpm_ws = vim.fs.find('pnpm-workspace.yaml', {
    path = parent,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
  if pnpm_ws then
    return vim.fs.dirname(pnpm_ws)
  end

  -- npm/yarn use "workspaces" field in root package.json
  local root_pkg = vim.fs.find('package.json', {
    path = parent,
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
  if root_pkg then
    local content = vim.fn.json_decode(vim.fn.readfile(root_pkg))
    if content.workspaces then
      return vim.fs.dirname(root_pkg)
    end
  end
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
