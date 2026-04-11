return {
  'rmagatti/auto-session',
  lazy = false,

  config = function()
    require('auto-session').setup({
      suppressed_dirs = { '~/', '~/workspace', '~/Downloads', '/', '~/tmp',  },
      -- log_level = 'debug',
      purge_after_minutes = 10080, -- 7 days
    })

    -- Delete session and quit without saving a new one
    local delete_and_quit = function()
      vim.cmd('AutoSession disable')
      vim.cmd('AutoSession delete')
      -- Disable auto-save to prevent saving a new session on quit
      vim.cmd('qa')
    end

    vim.keymap.set('n', '<leader>xd', delete_and_quit, { desc = 'Delete auto-session and quit' })
    vim.keymap.set('n', '<leader>xD', delete_and_quit, { desc = 'Delete auto-session and quit' })
  end,
}
