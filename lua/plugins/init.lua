vim.g.NVIM_CONFIG_DIR = os.getenv('MYVIMRC'):match('(.*[/\\])')
vim.g.PLUGINS_DIR = vim.g.NVIM_CONFIG_DIR .. 'lua/plugins/'
vim.g.COMPILED_PACKER_FILE = vim.g.NVIM_CONFIG_DIR .. 'plugin/packer_compiled.lua'

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
    clone_timeout = 300, -- in seconds
  },
})
return packer.startup(function(use)
  local init_file = vim.g.PLUGINS_DIR .. 'init.lua'
  local paths = vim.split(vim.fn.glob(vim.g.PLUGINS_DIR .. '**/*.lua'), '\n')
  for k, v in pairs(paths) do
    if v ~= init_file then
      use(dofile(v))
    end
  end
end)
