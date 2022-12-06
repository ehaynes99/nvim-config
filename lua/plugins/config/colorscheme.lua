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
  -- local nordfox_default_pallete = {
  --   black = Shade.new('#3b4252', '#465780', '#353a45'),
  --   red = Shade.new('#bf616a', '#d06f79', '#a54e56'),
  --   green = Shade.new('#a3be8c', '#b1d196', '#8aa872'),
  --   yellow = Shade.new('#ebcb8b', '#f0d399', '#d9b263'),
  --   blue = Shade.new('#81a1c1', '#8cafd2', '#668aab'),
  --   magenta = Shade.new('#b48ead', '#c895bf', '#9d7495'),
  --   cyan = Shade.new('#88c0d0', '#93ccdc', '#69a7ba'),
  --   white = Shade.new('#e5e9f0', '#e7ecf4', '#bbc3d4'),
  --   orange = Shade.new('#c9826b', '#d89079', '#b46950'),
  --   pink = Shade.new('#bf88bc', '#d092ce', '#a96ca5'),
  --
  --   comment = '#60728a',
  --
  --   bg0 = '#232831', -- Dark bg (status line and float)
  --   bg1 = '#2e3440', -- Default bg
  --   bg2 = '#39404f', -- Lighter bg (colorcolm folds)
  --   bg3 = '#444c5e', -- Lighter bg (cursor line)
  --   bg4 = '#5a657d', -- Conceal, border fg
  --
  --   fg0 = '#c7cdd9', -- Lighter fg
  --   fg1 = '#cdcecf', -- Default fg
  --   fg2 = '#abb1bb', -- Darker fg (status line)
  --   fg3 = '#7e8188', -- Darker fg (line numbers, fold colums)
  --
  --   sel0 = '#3e4a5b', -- Popup bg, visual selection bg
  --   sel1 = '#4f6074', -- Popup sel bg, search bg
  -- }
  require('nightfox').setup({
    options = {
      dim_inactive = true,
    },
    palettes = {
      nordfox = {
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
