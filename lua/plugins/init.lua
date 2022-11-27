local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer close and reopen Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

-- local packer_loaded, packer = pcall(require, 'packer')
-- if not packer_loaded then
--   return
-- end
local packer = require('packer')

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
  use({ 'wbthomason/packer.nvim', commit = '6afb67460283f0e990d35d229fd38fdc04063e0a' })

  use(require('plugins.onedark'))
  use(require('plugins.nvim-notify'))

  use({ 'rafcamlet/nvim-luapad', commit = '6efe3806c6e0d9ae684d756d4d7053cbdfb562eb' })
  use({ 'numToStr/Comment.nvim', commit = '97a188a98b5a3a6f9b1b850799ac078faa17ab67' })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
