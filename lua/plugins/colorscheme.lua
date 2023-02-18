local colorscheme = (function()
  local env_scheme = os.getenv('NVIM_COLORSCHEME')
  if env_scheme then
    return env_scheme
  elseif os.getenv('SSH_TTY') then
    return 'nordfox'
  end
  return 'kanagawa'
end)()

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

      if colorscheme == 'kanagawa' then
        vim.cmd('colorscheme kanagawa')
      end
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
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
      print('colorscheme: ' .. colorscheme)
      if colorscheme == 'nordfox' then
        vim.cmd('colorscheme nordfox')
      end
    end,
  },
}
