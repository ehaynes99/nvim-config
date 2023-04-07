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
          palette = {
            sumiInk0 = '#16161D',
            sumiInk1 = '#24242d',
            sumiInk3 = '#292932',
            sumiInk4 = '#2f2f3c',
            sumiInk5 = '#3b3b4b',
          },
          theme = {
            wave = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      })

      if colorscheme == 'kanagawa' then
        vim.cmd('colorscheme kanagawa-wave')
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
      if colorscheme == 'nordfox' then
        vim.cmd('colorscheme nordfox')
      end
    end,
  },
}
