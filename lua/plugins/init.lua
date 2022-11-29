local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
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

-- remove compiled plugins when any file in `lua/plugins` changes
vim.api.nvim_create_autocmd({ 'BufWrite' }, {
  pattern = vim.g.PLUGINS_DIR .. '**',
  callback = function(args)
    local dirty = vim.fn.getbufinfo(args.buf)[1].changed ~= 0
    if dirty and compiled_packer_exists() then
      os.remove(vim.g.COMPILED_PACKER_FILE)
      print('Removed compiled plugins')
    end
  end,
})

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
