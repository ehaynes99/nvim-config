local M = {}

local ROOT_MARKERS = { 'pyrightconfig.json', 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' }

local function is_uv_workspace(pyproject)
  if not vim.uv.fs_stat(pyproject) then return false end
  for line in io.lines(pyproject) do
    if line:match('^%[tool%.uv%.workspace%]') then return true end
  end
  return false
end

-- A uv workspace member has its own pyproject.toml, but imports and the shared
-- .venv only resolve from the workspace root above it.
M.root_dir = function(bufnr, on_dir)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local home = vim.fn.expand('$HOME')
  for dir in vim.fs.parents(path) do
    if dir == home then break end
    if is_uv_workspace(vim.fs.joinpath(dir, 'pyproject.toml')) then
      on_dir(dir)
      return
    end
  end
  on_dir(vim.fs.root(bufnr, ROOT_MARKERS))
end

M.find_venv = function(root)
  if not root then return nil end
  return vim.fs.find('.venv', {
    path = root,
    upward = true,
    type = 'directory',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1]
end

M.venv_bin = function(root, name)
  local venv = M.find_venv(root)
  local bin = venv and vim.fs.joinpath(venv, 'bin', name)
  if bin and vim.fn.executable(bin) == 1 then return bin end
  return nil
end

return M
