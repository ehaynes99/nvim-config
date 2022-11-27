-- setmetatable(_G, {
--   __index = function(_, key)
--     error('undefined variable `' .. key .. '` used', 2)
--   end,
-- })
require('options')
require('keymaps')
require('plugins')
require('autocommands')
