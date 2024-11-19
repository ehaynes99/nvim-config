return {
  'folke/zen-mode.nvim',
  keys = { { '<leader>wz', '<cmd>ZenMode<CR>', mode = { 'n' } } },
  opts = {
    window = {
      backdrop = 0.9,
      width = 0.9,
    },
    plugins = {
      -- disable some global vim options (vim.o...)
      -- comment the lines to not apply the options
      options = {
        enabled = true,
        ruler = true,
        showcmd = true,
        -- you may turn on/off statusline in zen mode by setting 'laststatus'
        -- statusline will be shown only if 'laststatus' == 3
        laststatus = 3,
      },
    },
  },
}
