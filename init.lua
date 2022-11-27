vim.g.NVIM_CONFIG_DIR = os.getenv('MYVIMRC'):match('(.*[/\\])')
vim.g.PLUGINS_DIR = vim.g.NVIM_CONFIG_DIR .. 'lua/plugins/'
vim.g.COMPILED_PACKER_FILE = vim.g.NVIM_CONFIG_DIR .. 'plugin/packer_compiled.lua'

require('options')
require('keymaps')
require('plugins')
require('autocommands')

-- setmetatable(_G, {
--   __index = function(_, key)
--     error('undefined variable `' .. key .. '` used', 2)
--   end,
-- })
