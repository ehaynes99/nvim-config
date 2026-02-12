local editor_utils = require('utils.editor')
local lua_utils = require('utils.lua')

local curry = lua_utils.curry
local set = vim.keymap.set

-- For some reason, mapping to '<ESC> :wincmd h<CR>' doesn't work if a file is empty
local wincmd = function(key)
  return function()
    vim.cmd('stopinsert')
    vim.cmd('wincmd ' .. key)
  end
end

local M = {}

M.lsp_keymaps = function(bufnr, lsp_format)
  local telescope = require('telescope.builtin')
  if lsp_format then
    -- set('<leader>lf', lsp_format, { desc = 'LSP: Format document', buffer = bufnr })
    set({ 'n', 'i' }, 'qf', lsp_format, { desc = 'LSP: Format document', buffer = bufnr })
  end
  set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: Goto declaration', buffer = bufnr })
  set('n', 'gd', telescope.lsp_definitions, { desc = 'LSP: Goto definition', buffer = bufnr })
  set('n', 'gt', telescope.lsp_type_definitions, { desc = 'LSP: Goto type definition', buffer = bufnr })
  set('n', 'gi', telescope.lsp_implementations, { desc = 'LSP: Goto implementation', buffer = bufnr })
  set('n', 'gr', telescope.lsp_references, { desc = 'LSP: Find references', buffer = bufnr })
  set('n', 'gR', vim.lsp.buf.references, { desc = 'LSP: Find references', buffer = bufnr })
  set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'LSP: Open diagnostics', buffer = bufnr })
  set('n', '<leader>lh', vim.lsp.buf.hover, { desc = 'LSP: Hover tooltip', buffer = bufnr })
  set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'LSP: Code actions native', buffer = bufnr })
  set('n', '<leader>lp', ':TroubleToggle<CR>', { desc = 'LSP: Trouble window', buffer = bufnr })
  set('n', '<leader>lj', curry(vim.diagnostic.goto_next)({ buffer = 0 }), { desc = 'LSP: Next diagnostic', buffer = bufnr })
  set('n', '<leader>lk', curry(vim.diagnostic.goto_prev)({ buffer = 0 }), { desc = 'LSP: Previous diagnostic', buffer = bufnr })
  set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'LSP: Rename', buffer = bufnr })
  set('n', '<leader>ls', vim.lsp.buf.signature_help, { desc = 'LSP: Signature help', buffer = bufnr })
  set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'LSP: Set loclist', buffer = bufnr })
end

M.init = function()
  local spectre = require('spectre')
  local telescope = require('telescope.builtin')
  local tu = require('utils.telescope')
  
  set('i', 'jk', '<ESC>', { desc = 'Leave insert' })
  set('n', 'Q', '<NOP>', { desc = 'Disable ex mode' })

  set('n', '/', function()
    vim.api.nvim_feedkeys('/', 'n', false)
    vim.api.nvim_feedkeys('\\v', 'n', false)
  end, { desc = 'Regex search forward by default' })

  set('n', '?', function()
    vim.api.nvim_feedkeys('?', 'n', false)
    vim.api.nvim_feedkeys('\\v', 'n', false)
  end, { desc = 'Regex search backward by default' })

  -- Movement
  set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
  set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
  set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
  set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
  set('x', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move down' })
  set('x', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move up' })

  set({ 'n', 'i', 'x', 't' }, '<A-h>', ':tabprevious<CR>', { desc = 'Go to previous tab' })
  set({ 'n', 'i', 'x', 't' }, '<A-l>', ':tabnext<CR>', { desc = 'Go to next tab' })

  -- Find
  set('n', '<leader>ff', tu.find_files, { desc = 'Find: files' })
  set('n', '<leader>fF', tu.find_files_in_project, { desc = 'Find: files in project' })
  set('n', '<leader>/', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find: text' })
  set('n', '<leader>?', tu.live_grep_without_tests, { desc = 'Find: text excluding tests' })
  set('n', '<leader>fs', require('telescope-live-grep-args.shortcuts').grep_word_under_cursor, { desc = 'Find: word under cursor' })
  set('n', '<leader>fs', require('telescope-live-grep-args.shortcuts').grep_word_under_cursor, { desc = 'Find: word under cursor' })
  set('n', '<leader>fS', tu.live_grep_word_under_cursor_without_tests, { desc = 'Find: word under cursor excluding tests' })
  set('n', '<leader>pfs', tu.live_grep_word_under_cursor_in_project, { desc = 'Find: word under cursor in project' })
  set('n', '<leader>fv', require('telescope-live-grep-args.shortcuts').grep_visual_selection, { desc = 'Find: visual selection' })
  set('n', '<leader>fp', tu.live_grep_in_project, { desc = 'Find: text in project' })
  set('n', '<leader>fP', tu.live_grep_in_project_without_tests, { desc = 'Find: text in project excluding tests' })
  set('n', '<leader>fw', editor_utils.search_tree_dir, { desc = 'Find: text within tree dir' })
  set('n', '<leader>fr', spectre.open_file_search, { desc = 'Spectre: Find replace' })
  set('n', '<leader>fR', spectre.open, { desc = 'Spectre: Global find replace' })
  set({ 'v', 'x' }, '<leader>fr', spectre.open_file_search, { desc = 'Spectre: Find replace' })
  set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find: Ripgrep' })

  -- Git
  set('n', '<leader>gc', tu.git_commits, { desc = 'Git: show commits' })
  set('n', '<leader>gh', tu.git_bcommits, { desc = 'Git: show commits for file' })
  set('n', '<leader>gB', tu.git_branches, { desc = 'Git: branches' })
  set('n', '<leader>gb', ':BlamerToggle<CR>', { desc = 'Git: show blame' })
  set({ 'n', 'x' }, '<Leader>gf', ':OpenInGHFileLines<CR>', { desc = 'Git: open selected lines in github' })
  set({ 'n', 'x' }, '<Leader>gF', ':OpenInGHFile<CR>', { desc = 'Git: open file in github' })

  -- LSP common
  set('n', '<leader>ll', ':LspRestart<CR>', { desc = 'LSP: Restart' })
  set('n', '<leader>lI', ':LspInfo<CR>', { desc = 'LSP: Info' })

  -- Macros
  set('n', '<leader>q', 'q', { desc = 'Start/stop recording macro' })
  set('n', 'q', '<Nop>')

  -- Text
  set('n', '<C-J>', 'mzJ`z', { desc = 'Join lines & preserve cursor' })
  set('n', '<leader>vw', 'ggVG', { desc = 'Select all' })
  set('n', 'Y', 'y$', { desc = 'Yank to end of line' })
  set({ 'n', 'x' }, 'j', "v:count ? 'j' : 'gj'", { desc = 'Move cursor up', expr = true })
  set({ 'n', 'x' }, 'k', "v:count ? 'k' : 'gk'", { desc = 'Move cursor down', expr = true })
  set({ 'n', 'x' }, '<Down>', "v:count ? 'j' : 'gj'", { desc = 'Move cursor up', expr = true })
  set({ 'n', 'x' }, '<Up>', "v:count ? 'k' : 'gk'", { desc = 'Move cursor down', expr = true })
  set('n', '<leader>ww', ':setl wrap!<CR>', { desc = 'Toggle soft wrap' })
  set('n', '<leader>wu', ':UndotreeToggle<CR>', { desc = 'Toggle undo tree' })
  set('n', '<leader>ws', ':tabdo wincmd =<CR>', { desc = 'Make windows even' })
  set('n', '<leader>wt', ':tabclose<CR>', { desc = 'Close tab' })
  set('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Global replace word under cursor', silent = false })
  set('x', '<leader>r', [["hy:%s/<C-r>h//gI<left><left><left>]], { desc = 'Replace selected text', silent = false })

  -- Window
  set('n', '<leader>wc', '<cmd>:BDelete this<CR>', { desc = 'Window: close current buffer' })
  set('n', '<leader>wh', editor_utils.close_hidden_buffers, { desc = 'Window: close all hidden buffers' })
  set('n', '<leader>wp', editor_utils.close_buffers_not_in_project, { desc = 'Window: close buffers not in project' })
  set('n', '<leader>wa', editor_utils.close_all_buffers, { desc = 'Window: close all buffers' })
  set('n', '<leader>wo', ':SymbolsOutline<CR>', { desc = 'Toggle symbols outline' })
  set('n', '<leader>wx', '<cmd>!chmod +x %<CR>', { desc = 'Toggle file executable' })
  set('n', '<leader>wd', editor_utils.toggle_diff, { desc = 'Diff with split pane' })
  set('n', '<leader>wn', ':set rnu!<CR>', { desc = 'Toggle relative line numbers' })

  set('n', '<LeftDrag>', '', { desc = 'Disable left drag' })
  set('n', '<LeftRelease>', '', { desc = 'Disable left drag' })
  set('n', '<RightDrag>', '', { desc = 'Disable right drag' })
  set('n', '<RightRelease>', '', { desc = 'Disable right drag' })
  set({ 'n', 'i', 'x', 't' }, '<C-h>', wincmd('h'), { desc = 'Window: focus left' })
  set({ 'n', 'i', 'x', 't' }, '<C-j>', wincmd('j'), { desc = 'Window: focus down' })
  set({ 'n', 'i', 'x', 't' }, '<C-k>', wincmd('k'), { desc = 'Window: focus up' })
  set({ 'n', 'i', 'x', 't' }, '<C-l>', wincmd('l'), { desc = 'Window: focus right' })
  set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Window: resize taller' })
  set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Window: resize shorter' })
  set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Window: resize narrower' })
  set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Window: resize wider' })

  -- Terminal
  -- set('t', '<ESC><ESC>', '<C-\\><C-n>', { desc = 'Leave insert' })
  set('t', '<C-]>', '<C-\\><C-n>', { desc = 'Leave insert in terminals' })

  -- Editor
  set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Window: cancel highlight' })
  set('x', 'p', '"_dP', { desc = 'Paste without copying replaced' })
  set('x', '<C-p>', 'p', { desc = 'Paste and yank' })
  set('x', '<', '<gv', { desc = 'Stay in visual mode after indent left' })
  set('x', '>', '>gv', { desc = 'Stay in visual mode after indent left' })
  set({ 'n', 'i' }, '<C-/>', require('Comment.api').toggle.linewise.current, { desc = 'Comment toggle' })
  set('x', '<C-/>', function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end, { desc = 'Comment toggle' })
  set('x', '<leader>cc', function()
    vim.api.nvim_feedkeys('y', 'nx', false)
    local mark = vim.api.nvim_buf_get_mark(0, '<')
    local keys = vim.api.nvim_replace_termcodes('Pgv<ESC>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'nx', false)
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
    vim.api.nvim_win_set_cursor(0, mark)
  end, { desc = 'Copy and comment visual selection' })
  set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = 'Markdown Preview' })

  -- Telescope
  set('n', '<leader>tt', tu.builtin, { desc = 'Telescope: builtin' })
  set('n', '<leader>tk', tu.keymaps, { desc = 'Telescope: keymaps' })
  set('n', '<leader>tc', telescope.commands, { desc = 'Telescope: commands' })
  set('n', '<leader>tb', tu.buffers, { desc = 'Find: buffers' })
  set('n', '<leader>fb', tu.buffers, { desc = 'Find: buffers' })
  set('n', '<leader>td', telescope.diagnostics, { desc = 'Telescope: commands' })
  set('n', '<leader>th', telescope.help_tags, { desc = 'Telescope: help tags' })
  set('n', '<leader>tr', telescope.resume, { desc = 'Telescope: resume' })
  set('n', '<leader>ta', telescope.autocommands, { desc = 'Telescope: autocommands' })

  -- Testing
  set('n', '<leader>xl', '<cmd>:Luapad<CR>', { desc = 'Luapad' })
  set('n', '<leader>xx', '<cmd>:LuaRun<CR>', { desc = 'Run current file' })
  set('n', '<leader>xb', require('utils.editor').all_buffers, { desc = 'Print buffer info' })
end

return M
