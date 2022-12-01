local M = {}

M.project_root = function(path)
  for dir in vim.fs.parents(path) do
    local pkgfile = dir .. '/package.json'
    if vim.fn.filereadable(pkgfile) ~= 0 then
      return dir
    end
  end
end

return M
