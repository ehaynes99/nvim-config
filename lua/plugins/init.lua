-- Automatically install packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    print('Installing packer.')
    vim.cmd([[packadd packer.nvim]])
  end
  return require('packer')
end

local packer = ensure_packer()

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
  git = {
    default_url_format = 'git@github.com:%s',
  },
})

-- add disabled plugins here
local ignored = {
  'init.lua',
  'neo-tree.lua',
  'cmp-nvim-lsp.lua',
}

local is_ignored = function(path)
  for _, ignored_file in pairs(ignored) do
    if path == (vim.g.PLUGINS_DIR .. ignored_file) then
      return true
    end
  end
end

return packer.startup(function(use)
  local paths = vim.split(vim.fn.glob(vim.g.PLUGINS_DIR .. '**/*.lua'), '\n')
  for _, path in pairs(paths) do
    if not is_ignored(path) then
      -- if path ~= init_file then
      use(dofile(path))
    end
  end
end)
