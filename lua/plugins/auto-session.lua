return {
  'rmagatti/auto-session',
  dependencies = {
    -- { 'rmagatti/session-lens', config = true },
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
    })
    -- require('session-lens').setup({})

    vim.keymap.set(
      'n',
      '<leader>tS',
      ':Telescope session-lens search_session<CR>',
      { desc = 'Telescope: autocommands' }
    )
  end,
}
