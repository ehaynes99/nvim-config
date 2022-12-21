local project_utils = require('utils.project')

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel' },
  callback = function()
    vim.keymap.set('n', 'q', vim.cmd.close)
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

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
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

    local ok, stats = pcall(vim.loop.fs_stat, name)
    if ok and stats and (stats.size > 512 * 1024) then
      vim.bo[buf].large_buf = true
      vim.cmd('syntax off')
      vim.cmd('IndentBlanklineDisable')
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.spell = false
    else
      vim.b.large_buf = false
    end
  end,
})

-- also fires on rename, which we want
vim.api.nvim_create_autocmd('BufNew', {
  callback = function(args)
    local buf = args.buf
    local buftype = vim.bo[buf].buftype
    if buftype ~= '' or args.file == '' then
      return
    end
    local git_root = project_utils.git_root(args.file)
    vim.api.nvim_buf_set_var(buf, 'git_root', git_root)
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  pattern = '*',
  callback = function()
    -- pre-close teardown
  end,
})
