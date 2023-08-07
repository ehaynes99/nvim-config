return {
  'rmagatti/auto-session',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local keymaps = require('keymaps')
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

    keymaps.add({
      { '<leader>tS', require('auto-session.session-lens').search_session, desc = 'Telescope: autocommands' },
      { '<leader>wd', ':SessionDelete<CR>', desc = 'auto-session: delete session' },
      {
        '<leader>wD',
        function()
          vim.cmd('SessionDelete')
          vim.cmd(':qa')
        end,
        desc = 'auto-session: delete session',
      },
    })
  end,
}
