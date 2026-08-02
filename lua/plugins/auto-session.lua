return {
  'rmagatti/auto-session',
  lazy = false,

  config = function()
    require('auto-session').setup({
      suppressed_dirs = { '~/', '~/workspace', '~/Downloads', '/', '~/tmp',  },
      -- log_level = 'debug',
      purge_after_minutes = 10080, -- 7 days
      close_filetypes_on_save = { 'checkhealth' },
      pre_save_cmds = {
        function()
          -- auto-session's close_filetypes_on_save only closes the FIRST
          -- matching buffer (upstream `break` bug in close_ignored_filetypes),
          -- so stale claudecode terminal buffers can accumulate across
          -- restarts and still get saved into the session, bypassing
          -- claudecode.nvim's env injection on restore. Close all of them.
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'claudecode' then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      },
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
