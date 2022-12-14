local project_utils = require('utils.project')

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel' },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]])
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
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

local cwd_cache = {}

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function(args)
    local buf = args.buf
    if cwd_cache[buf] == nil then
      local entry = {
        buf = buf,
        file = args.file,
        buftype = vim.api.nvim_buf_get_option(buf, 'buftype'),
      }
      cwd_cache[buf] = entry

      if entry.file and entry.file ~= '' and entry.buftype == '' then
        entry.root = project_utils.git_root(entry.file)
      end
    end

    -- TODO - remove this is not seen
    if cwd_cache[buf].file ~= args.file then
      local message =
        string.format('File mismatch! buf: %s previous: %s current: %s', buf, cwd_cache[buf].file, args.file)
      require('notify')(message, 'error')
    end

    local root = cwd_cache[buf].root

    local cwd = vim.fn.getcwd()
    print('root: ' .. (root or 'nil') .. ' cwd: ' .. cwd)
    if root and root ~= cwd then
      vim.cmd('lcd' .. root)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'VimLeavePre ' }, {
  pattern = '*',
  callback = function()
    -- pre-close teardown
  end,
})
