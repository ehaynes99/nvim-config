local default_scheme = 'nightfox'
local colorscheme = os.getenv('NVIM_COLORSCHEME') or default_scheme

local M = {}

M.onedark = function()
  local onedark = require('onedark')

  onedark.setup({
    style = 'warm',
  })

  vim.cmd('colorscheme onedark')
end

M.kanagawa = function()
  vim.cmd('colorscheme kanagawa')
end

M.nightfox = function()
  require('nightfox').setup({
    options = {
      dim_inactive = true,
    },
    palettes = {
      nordfox = {
        -- bg1 = '#2a303b',
        bg1 = '#282e38',
      },
    },
  })
  vim.cmd('colorscheme nordfox')
  -- vim.cmd('colorscheme duskfox')
  -- vim.cmd('colorscheme nightfox')
  -- vim.cmd('colorscheme nordfox')
  -- vim.cmd('colorscheme terafox')
  -- vim.cmd('colorscheme carbonfox')
end

M[colorscheme]()
