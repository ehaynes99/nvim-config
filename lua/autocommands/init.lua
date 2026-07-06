require('autocommands.auto_save')

-- Poll file mtimes every 200ms; call checktime only when something changed on disk.
-- Handles external changes (branch switches, tool edits) without requiring a buffer switch.
local _buf_mtimes = {}
local _disk_poll = vim.uv.new_timer()
_disk_poll:start(200, 200, vim.schedule_wrap(function()
  local changed = false
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name ~= '' then
        local mtime = vim.fn.getftime(name)
        if _buf_mtimes[bufnr] and mtime ~= _buf_mtimes[bufnr] then
          changed = true
        end
        _buf_mtimes[bufnr] = mtime
      end
    end
  end
  if changed then
    vim.cmd('silent! checktime')
  end
end))

vim.api.nvim_create_autocmd('FileType', {
  desc = 'bind "q" to close for certain filetypes',
  pattern = { 'qf', 'help', 'vimdoc', 'man', 'lspinfo', 'spectre_panel', 'tsplayground' },
  callback = function(args)
    vim.keymap.set('n', 'q', vim.cmd.close, { buffer = args.buf })
    vim.bo.buflisted = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'enable spellcheck and wrap for certain filetypes',
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'enable wrap for certain filetypes',
  pattern = { 'help', 'vimdoc' },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'resize windows when vim is resized',
  callback = function()
    local in_terminal = vim.bo.buftype == 'terminal'

    if in_terminal then
      vim.cmd('stopinsert')
    end

    vim.cmd('tabdo wincmd =')

    if not in_terminal then
      -- prefer left side of cursor visible to right side
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[ normal 999zh ]])
      vim.api.nvim_win_set_cursor(0, cursor)
    end

    if in_terminal then
      vim.cmd('startinsert')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  desc = 'leave insert mode when changing buffer or leaving nvim',
  callback = function()
    local is_file = vim.api.nvim_get_option_value('buftype', { buf = 0 }) == ''
    if is_file then
      vim.cmd('stopinsert')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  desc = 'Check for file changes when entering buffer or window',
  callback = function()
    if vim.bo.buftype == '' then
      vim.cmd('checktime')
    end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Set buffer navigation keymaps for normal file buffers',
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
    local buflisted = vim.api.nvim_get_option_value('buflisted', { buf = args.buf })

    -- Only set keymaps for normal files (empty buftype, listed buffers)
    if buftype == '' and buflisted then
      vim.keymap.set('n', '<S-l>', ':bnext<CR>', { desc = 'Window: next buffer', buffer = args.buf })
      vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { desc = 'Window: previous buffer', buffer = args.buf })
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  desc = 'Clear search highlight when leaving a buffer',
  callback = function()
    vim.schedule(function()
      vim.v.hlsearch = 0
    end)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Close buffers that will break with sessions',
  pattern = { 'NvimTree', 'Trouble' },
  callback = function(args)
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_delete(args.buf, { force = true })
        end
        return true
      end,
    })
  end,
})

