return {
  -- 'coder/claudecode.nvim',
  dir = '/home/erich/workspace/ehaynes99/claudecode.nvim',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'claudecode',
      callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        vim.cmd('wincmd =')
      end,
    })

    vim.api.nvim_create_autocmd('BufWinEnter', {
      desc = 'Rebalance windows and enter insert mode when claudecode terminal is shown',
      callback = function(ev)
        if vim.bo[ev.buf].filetype == 'claudecode' then
          vim.cmd('wincmd =')
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) and vim.api.nvim_get_current_buf() == ev.buf then
              vim.cmd('startinsert')
            end
          end)
        end
      end,
    })

    require('claudecode').setup({
      terminal = {
        auto_close = true,
        -- buflisted = false,
      },
      focus_after_send = true,
      diff_opts = {
        keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
        open_in_new_tab = true, -- Open diff in a separate tab
      },
      -- log_level = 'debug',
    })
  end,
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'x', desc = 'Send selection to Claude' },
    { '<leader>as', '<cmd>.ClaudeCodeSend<cr>', mode = 'n', desc = 'Send line to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
