vim.g.blamer_date_format = '%m/%d/%y'
vim.g.blamer_delay = 100
vim.g.blamer_show_in_visual_modes = 0

return {
  'APZelos/blamer.nvim',
  keys = {
    { '<leader>gb', ':BlamerToggle<CR>', desc = 'Git: show blame' },
  },
  config = function()
    vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
      callback = function()
        vim.cmd('BlamerHide')
      end,
    })
  end,
}
