require('autocommands.auto_save')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel', 'tsplayground' },
  callback = function(args)
    vim.keymap.set('n', 'q', vim.cmd.close, { buffer = args.buf })
    vim.bo.buflisted = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help' },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- leave insert mode when changing buffer or leaving nvim
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  callback = function()
    local is_file = vim.api.nvim_buf_get_option(0, 'buftype') == ''
    if is_file then
      vim.cmd('stopinsert')
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  callback = function(args)
    local buf = args.buf
    local name = vim.api.nvim_buf_get_name(buf)

    if vim.fn.getfsize(name) > (1024 * 1024) then
      vim.b[buf].large_buf = true
      vim.cmd('syntax off')
      vim.cmd('IndentBlanklineDisable')
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.spell = false
    else
      vim.b[buf].large_buf = false
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'NvimTree*',
  callback = function()
    local view = require('nvim-tree.view')
    local is_visible = view.is_visible()

    local api = require('nvim-tree.api')
    if not is_visible then
      api.tree.open()
    end
  end,
})
