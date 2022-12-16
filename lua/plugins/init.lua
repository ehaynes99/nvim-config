vim.g.COMPILED_PACKER_FILE = vim.fn.stdpath('config') .. '/plugin/packer_compiled.lua'

local ensure_packer = function()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')

local compiled_packer_exists = function()
  local f = io.open(vim.g.COMPILED_PACKER_FILE, 'r')
  if f ~= nil then
    io.close(f)
    return true
  end
end

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

return packer.startup(function(use)
  for _, plugin in pairs(require('plugins.plugins')) do
    use(plugin)
  end
  if packer_bootstrap or not compiled_packer_exists() then
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = { 'PackerComplete' },
      callback = function()
        require('plugins.config')
        return true
      end,
    })
    require('packer').sync()
  else
    require('plugins.config')
  end
end)
