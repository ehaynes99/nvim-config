local utils = require('lua.utils')

local create_cmd = vim.api.nvim_create_autocmd

local NVIM_CONFIG_DIR = os.getenv('MYVIMRC'):match('(.*[/\\])')
local PLUGINS_DIR = NVIM_CONFIG_DIR .. 'lua/plugins/'
local COMPILED_PACKER_FILE = NVIM_CONFIG_DIR .. 'plugin/packer_compiled.lua'

local compiled_packer_exists = function()
  local f = io.open(COMPILED_PACKER_FILE, 'r')
  if f ~= nil then
    io.close(f)
    return true
  end
end

-- remove compiled plugins when any file in `lua/plugins` changes
create_cmd({ 'BufWrite' }, {
  pattern = PLUGINS_DIR .. '**',
  callback = function(args)
    if utils.is_buffer_dirty(args.buf) and compiled_packer_exists() then
      local notify = require('notify')
      os.remove(COMPILED_PACKER_FILE)
      notify('Removed compiled plugins')
    end
  end,
})

create_cmd({ 'VimEnter' }, {
  callback = function()
    if not compiled_packer_exists() then
      local packer_loaded, packer = pcall(require, 'packer')
      if packer_loaded then
        packer.sync()
      end
    end
  end,
})
