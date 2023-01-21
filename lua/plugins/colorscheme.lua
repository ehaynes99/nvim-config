-- local default_scheme = 'kanagawa'
-- local colorscheme = os.getenv('NVIM_COLORSCHEME') or default_scheme

return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        dimInactive = true,
        colors = {
          sumiInk0 = '#16161D',
          sumiInk1 = '#292932',
          sumiInk1b = '#24242d',
          sumiInk2 = '#2f2f3c',
          sumiInk3 = '#3b3b4b',
        },
      })

      vim.cmd('colorscheme kanagawa')
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    event = 'VeryLazy',
    config = function()
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
      -- vim.cmd('colorscheme nordfox')
    end,
  },
}
