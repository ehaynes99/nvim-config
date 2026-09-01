local function relative_path()
  return vim.fn.expand('%:.')
end

local function copy_ref(ref)
  vim.fn.setreg('"', ref)
  vim.fn.setreg('+', ref)
  vim.notify('Copied ' .. ref, vim.log.levels.INFO)
end

local function copy_buffer_ref()
  copy_ref('@' .. relative_path())
end

local function copy_line_ref()
  copy_ref(string.format('@%s#L%d', relative_path(), vim.fn.line('.')))
end

local function copy_selection_ref()
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  if start_line == end_line then
    copy_ref(string.format('@%s#L%d', relative_path(), start_line))
  else
    copy_ref(string.format('@%s#L%d-%d', relative_path(), start_line, end_line))
  end
  vim.cmd('normal! \27')
end

local function copy_tree_node_ref()
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end
  local path = vim.fn.fnamemodify(node.absolute_path, ':.')
  copy_ref('@' .. path)
end

return {
  -- 'coder/claudecode.nvim',
  -- dir = '/home/erich/workspace/ehaynes99/claudecode.nvim',
  'ehaynes99/claudecode.nvim',
  branch = 'merged-fixes',
  lazy = false,
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
    timer:start(
      50,
      50,
      vim.schedule_wrap(function()
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
      end)
    )

    require('claudecode').setup({
      terminal = {
        provider = 'native',
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
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>aB', copy_buffer_ref, desc = 'Copy current buffer ref' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'x', desc = 'Send selection to Claude' },
    { '<leader>as', '<cmd>.ClaudeCodeSend<cr>', mode = 'n', desc = 'Send line to Claude' },
    { '<leader>aS', copy_selection_ref, mode = 'x', desc = 'Copy selection ref' },
    { '<leader>aS', copy_line_ref, mode = 'n', desc = 'Copy line ref' },
    {
      '<leader>ab',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    {
      '<leader>aB',
      copy_tree_node_ref,
      desc = 'Copy file ref',
      ft = { 'NvimTree' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
