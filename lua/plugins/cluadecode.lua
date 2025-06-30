return {
  -- 'coder/claudecode.nvim',
  dir = '/home/erich/workspace/ehaynes99/claudecode.nvim',
  opts = {
    terminal_cmd = 'npx -y -p @anthropic-ai/claude-code claude',
    terminal = {
      auto_close = false,
    },
    -- log_level = 'debug',
  },
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'x', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree' },
    },
  },
}
