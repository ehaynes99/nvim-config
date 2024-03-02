require('autocommands.auto_save')

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
    vim.cmd('tabdo wincmd =')

    -- prefer left side of cursor visible to right side
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[ normal 999zh ]])
    vim.api.nvim_win_set_cursor(0, cursor)
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

-- vim.api.nvim_create_autocmd('BufEnter', {
--   desc = 'reload file when it changes on disk',
--   callback = function()
--     vim.cmd('checktime')
--   end,
-- })

vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Disable some slow operations on large files',
  callback = function(args)
    local buf = args.buf
    local name = vim.api.nvim_buf_get_name(buf)

    if vim.fn.getfsize(name) > (2 * 1024 * 1024) then
      vim.b[buf].large_buf = true
      vim.cmd('syntax off')
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

-- TODO: figure out better SQL lsp integration
vim.api.nvim_create_autocmd('BufRead', {
  desc = 'Add SQL formatting',
  pattern = { '*.sql' },
  callback = function(args)
    vim.lsp.buf.format({
      async = true,
      bufnr = args.buf,
      filter = function(client)
        return client.name == 'null-ls'
      end,
    })
    require('keymaps').add({
      {
        '<leader>lf',
        ':%!' .. vim.fn.stdpath('data') .. '/mason/packages/sqlfluff/venv/bin/sqlfluff format --dialect postgres -<CR>',
        desc = 'Format SQL file',
        buffer = args.buf,
      },
    })
  end,
})
