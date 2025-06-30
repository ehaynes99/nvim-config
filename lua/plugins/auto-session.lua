return {
  'rmagatti/auto-session',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('auto-session').setup({
      log_level = 'error',
      auto_session_suppress_dirs = {
        '~/',
        '~/tmp',
        '~/workspace',
        '~/all-workspaces',
        '/',
        '/tmp',
      },
      session_lens = {},
    })

    vim.keymap.set('n', '<leader>tS', require('auto-session.session-lens').search_session, { desc = 'Telescope: autocommands' })
    vim.keymap.set('n', '<leader>xD', function()
      vim.cmd('SessionDelete')
      vim.cmd(':qa')
    end, { desc = 'auto-session: delete session' })
  end,
}
