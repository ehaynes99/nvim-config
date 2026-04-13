return {
  -- 'coder/claudecode.nvim',
  -- 'ehaynes99/claudecode.nvim',
  dir = '/home/erich/workspace/ehaynes99/claudecode.nvim',
  lazy = false,
  -- branch = 'merged-fixes',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'claudecode',
      callback = function(ev)
        vim.bo[ev.buf].buflisted = false
        vim.schedule(function()
          vim.cmd('noautocmd wincmd =')
        end)

        -- Buffer-local <C-]> that flags explicit normal mode
        vim.keymap.set('t', '<C-]>', function()
          vim.b[ev.buf].claudecode_explicit_normal = true
          vim.cmd([[stopinsert]])
        end, { buffer = ev.buf, desc = 'Leave insert in claudecode terminal' })
      end,
    })

    -- Clear the explicit normal flag when user re-enters terminal mode
    vim.api.nvim_create_autocmd('TermEnter', {
      desc = 'Clear explicit normal mode flag for claudecode terminal',
      callback = function()
        if vim.bo.filetype == 'claudecode' then
          vim.b.claudecode_explicit_normal = false
        end
      end,
    })

    -- Equalize windows when entering a claudecode buffer
    vim.api.nvim_create_autocmd('BufEnter', {
      desc = 'Equalize windows when focusing claudecode terminal',
      callback = function()
        if vim.bo.filetype == 'claudecode' then
          vim.cmd('noautocmd wincmd =')
        end
      end,
    })

    -- Poll: force insert mode unless user explicitly requested normal mode
    local timer = vim.uv.new_timer()
    timer:start(50, 50, vim.schedule_wrap(function()
      if vim.api.nvim_get_mode().mode ~= 'nt' then
        return
      end
      if vim.bo.filetype ~= 'claudecode' then
        return
      end
      if vim.b.claudecode_explicit_normal then
        return
      end
      vim.cmd('startinsert')
    end))

    require('claudecode').setup({
      terminal = {
        auto_close = true,
        -- buflisted = false,
      },
      -- env = { CLAUDE_CODE_NO_FLICKER = '1' },
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
