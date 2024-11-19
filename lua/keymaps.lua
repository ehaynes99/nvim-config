local editor_utils = require('utils.editor')
local lua_utils = require('utils.lua')

local curry = lua_utils.curry

-- For some reason, mapping to '<ESC> :wincmd h<CR>' doesn't work if a file is empty
local wincmd = function(key)
  return function()
    vim.cmd('stopinsert')
    vim.cmd('wincmd ' .. key)
  end
end

local M = {}

M.add = function(mappings)
  if type(mappings[1]) == 'string' then
    mappings = { mappings }
  end
  for _, mapping in ipairs(mappings) do
    local mode = (function()
      if mapping.mode == nil then
        return { 'n' }
      elseif type(mapping.mode) == 'string' then
        ---@diagnostic disable-next-line: missing-parameter
        return vim.split(mapping.mode, '')
      else
        return mapping.mode
      end
    end)()

    local opts = { silent = true }
    for k, v in pairs(mapping) do
      if type(k) == 'string' and not (k == 'mode') then
        opts[k] = v
      end
    end

    local key = mapping[1]
    local cmd = mapping[2]
    vim.keymap.set(mode, key, cmd, opts)
  end
end

M.lsp_keymaps = function(bufnr, lsp_format)
  local telescope = require('telescope.builtin')
  if lsp_format then
    M.add({
      -- { '<leader>lf', lsp_format, desc = 'LSP: Format document', buffer = bufnr },
      { 'qf', lsp_format, mode = 'ni', desc = 'LSP: Format document', buffer = bufnr },
    })
  end
  M.add({
    { 'gD', vim.lsp.buf.declaration, desc = 'LSP: Goto declaration', buffer = bufnr },
    { 'gd', telescope.lsp_definitions, desc = 'LSP: Goto definition', buffer = bufnr },
    { 'gt', telescope.lsp_type_definitions, desc = 'LSP: Goto type definition', buffer = bufnr },
    { 'gi', telescope.lsp_implementations, desc = 'LSP: Goto implementation', buffer = bufnr },
    { 'gr', telescope.lsp_references, desc = 'LSP: Find references', buffer = bufnr },
    { 'gR', vim.lsp.buf.references, desc = 'LSP: Find references', buffer = bufnr },
    { '<leader>ld', vim.diagnostic.open_float, desc = 'LSP: Open diagnostics', buffer = bufnr },
    { '<leader>lh', vim.lsp.buf.hover, desc = 'LSP: Hover tooltip', buffer = bufnr },
    { '<leader>la', vim.lsp.buf.code_action, desc = 'LSP: Code actions native', buffer = bufnr },
    { '<leader>lp', ':TroubleToggle<CR>', desc = 'LSP: Trouble window', buffer = bufnr },
    {
      '<leader>lj',
      curry(vim.diagnostic.goto_next)({ buffer = 0 }),
      desc = 'LSP: Next diagnostic',
      buffer = bufnr,
    },
    {
      '<leader>lk',
      curry(vim.diagnostic.goto_prev)({ buffer = 0 }),
      desc = 'LSP: Previous diagnostic',
      buffer = bufnr,
    },
    { '<leader>lr', vim.lsp.buf.rename, desc = 'LSP: Rename', buffer = bufnr },
    { '<leader>ls', vim.lsp.buf.signature_help, desc = 'LSP: Signature help', buffer = bufnr },
    { '<leader>lq', vim.diagnostic.setloclist, desc = 'LSP: Set loclist', buffer = bufnr },
  })
end

M.init = function()
  local spectre = require('spectre')
  local telescope = require('telescope.builtin')
  local tu = require('utils.telescope')
  M.add({
    { 'jk', '<ESC>', mode = 'i', desc = 'Leave insert' },
    { 'Q', '<NOP>', desc = 'Disable ex mode' },

    { '<A-j>', '<cmd>m .+1<cr>==', mode = 'n', desc = 'Move Down' },
    { '<A-k>', '<cmd>m .-2<cr>==', mode = 'n', desc = 'Move up' },
    { '<A-j>', '<esc><cmd>m .+1<cr>==gi', mode = 'i', desc = 'Move down' },
    { '<A-k>', '<esc><cmd>m .-2<cr>==gi', mode = 'i', desc = 'Move up' },
    { '<A-j>', ":m '>+1<CR>gv=gv", mode = 'x', desc = 'Move down' },
    { '<A-k>', ":m '<-2<CR>gv=gv", mode = 'x', desc = 'Move up' },

    { '<A-h>', ':tabprevious<CR>', mode = 'nixt', desc = 'Go to previous tab' },
    { '<A-l>', ':tabnext<CR>', mode = 'nixt', desc = 'Go to next tab' },

    -- Find
    { '<leader>ff', tu.find_files, desc = 'Find: files' },
    { '<leader>fF', tu.find_files_in_project, desc = 'Find: files in project' },
    { 'ff', tu.find_files, desc = 'Find: files' },
    { 'fF', tu.find_files_in_project, desc = 'Find: files in project' },
    -- { "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    { '<leader>/', require('telescope').extensions.live_grep_args.live_grep_args, desc = 'Find: text' },
    -- { '<leader>/', ':Telescope live_grep<CR>', desc = 'Find: text' },
    { '<leader>?', tu.live_grep_without_tests, desc = 'Find: text excluding tests' },
    { '<leader>fs', ':Telescope grep_string<CR>', desc = 'Find: word under cursor' },
    { '<leader>fp', tu.live_grep_in_project, desc = 'Find: text in project' },
    { '<leader>fP', tu.live_grep_in_project_without_tests, desc = 'Find: text in project excluding tests' },

    { '<leader>fw', editor_utils.search_tree_dir, desc = 'Find: text within tree dir' },
    { '<leader>fr', spectre.open_file_search, desc = 'Spectre: Find replace' },
    { '<leader>fR', spectre.open, desc = 'Spectre: Global find replace' },
    { '<leader>fr', spectre.open_file_search, mode = 'vx', desc = 'Spectre: Find replace' },
    { '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, desc = 'Find: Ripgrep' },

    -- git
    { '<leader>gc', tu.git_commits, desc = 'Git: show commits' },
    { '<leader>gh', tu.git_bcommits, desc = 'Git: show commits for file' },
    { '<leader>gB', tu.git_branches, desc = 'Git: branches' },
    { '<leader>gb', ':BlamerToggle<CR>', desc = 'Git: show blame' },
    { '<Leader>gf', ':OpenInGHFileLines<CR>', mode = 'nx', desc = 'Git: open selected lines in github' },
    { '<Leader>gF', ':OpenInGHFile<CR>', mode = 'nx', desc = 'Git: open file in github' },

    -- LSP common
    { '<leader>ll', ':LspRestart<CR>', desc = 'LSP: Restart' },
    { '<leader>lI', ':LspInfo<CR>', desc = 'LSP: Info' },

    -- macros
    { '<leader>q', 'q', desc = 'Start/stop recording macro' },
    { 'q', '<Nop>' },

    -- text
    { '<C-J>', 'mzJ`z', desc = 'Join lines & preserve cursor' },
    { '<leader>vw', 'ggVG', desc = 'Select all' },
    { 'Y', 'y$', desc = 'Yank to end of line' },
    { 'j', "v:count ? 'j' : 'gj'", mode = 'nx', desc = 'Move cursor up', expr = true },
    { 'k', "v:count ? 'k' : 'gk'", mode = 'nx', desc = 'Move cursor down', expr = true },
    { '<Down>', "v:count ? 'j' : 'gj'", mode = 'nx', desc = 'Move cursor up', expr = true },
    { '<Up>', "v:count ? 'k' : 'gk'", mode = 'nx', desc = 'Move cursor down', expr = true },
    { '<leader>ww', ':setl wrap!<CR>', desc = 'Toggle soft wrap' },
    { '<leader>wu', ':UndotreeToggle<CR>', desc = 'Toggle undo tree' },
    {
      '<leader>r',
      ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
      desc = 'Global replace word under cursor',
      silent = false,
    },
    {
      '<leader>r',
      [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      desc = 'Replace word under cursor',
      silent = false,
    },
    {
      '<leader>r',
      [["hy:%s/<C-r>h//gI<left><left><left>]],
      mode = 'x',
      desc = 'Replace selected text',
      silent = false,
    },

    -- Window
    { '<leader>wc', '<cmd>:BDelete this<CR>', desc = 'Window: close current buffer' },
    { '<leader>wh', editor_utils.close_hidden_buffers, desc = 'Window: close all hidden buffers' },
    { '<leader>wp', editor_utils.close_buffers_not_in_project, desc = 'Window: close buffers not in project' },
    { '<leader>wa', editor_utils.close_all_buffers, desc = 'Window: close all buffers' },
    { '<leader>wo', ':SymbolsOutline<CR>', desc = 'Toggle symbols outline' },
    { '<leader>wx', '<cmd>!chmod +x %<CR>', desc = 'Toggle file executable' },
    { '<leader>wd', editor_utils.toggle_diff, desc = 'Diff with split pane' },

    { '<LeftDrag>', '', desc = 'Disable left drag' },
    { '<LeftRelease>', '', desc = 'Disable left drag' },
    { '<RightDrag>', '', desc = 'Disable right drag' },
    { '<RightRelease>', '', desc = 'Disable right drag' },
    { '<S-l>', ':bnext<CR>', desc = 'Window: next buffer' },
    { '<S-h>', ':bprevious<CR>', desc = 'Window: previous buffer' },
    { '<C-h>', wincmd('h'), mode = 'nixt', desc = 'Window: focus left' },
    { '<C-j>', wincmd('j'), mode = 'nixt', desc = 'Window: focus down' },
    { '<C-k>', wincmd('k'), mode = 'nixt', desc = 'Window: focus up' },
    { '<C-l>', wincmd('l'), mode = 'nixt', desc = 'Window: focus right' },
    { '<C-Up>', ':resize +2<CR>', desc = 'Window: resize taller' },
    { '<C-Down>', ':resize -2<CR>', desc = 'Window: resize shorter' },
    { '<C-Left>', ':vertical resize -2<CR>', desc = 'Window: resize narrower' },
    { '<C-Right>', ':vertical resize +2<CR>', desc = 'Window: resize wider' },

    -- Terminal
    { '<ESC><ESC>', '<C-\\><C-n>', mode = 't', desc = 'Leave insert' },

    -- Editor
    { '<leader>n', ':set rnu!<CR>', desc = 'Toggle relative line numbers' },
    { '<leader>h', ':nohlsearch<CR>', desc = 'Window: cancel highlight' },
    { 'p', '"_dP', mode = 'x', desc = 'Paste without copying replaced' },
    { '<C-p>', 'p', mode = 'x', desc = 'Paste and yank' },
    { '<', '<gv', mode = 'x', desc = 'Stay in visual mode after indent left' },
    { '>', '>gv', mode = 'x', desc = 'Stay in visual mode after indent left' },
    { '<C-/>', require('Comment.api').toggle.linewise.current, mode = 'ni', desc = 'Comment toggle' },
    {
      '<C-/>',
      function()
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'nx', false)
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end,
      mode = 'x',
      desc = 'Comment toggle',
    },
    {
      '<leader>cc',
      function()
        vim.api.nvim_feedkeys('y', 'nx', false)
        local mark = vim.api.nvim_buf_get_mark(0, '<')
        local keys = vim.api.nvim_replace_termcodes('Pgv<ESC>', true, false, true)
        vim.api.nvim_feedkeys(keys, 'nx', false)
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
        vim.api.nvim_win_set_cursor(0, mark)
      end,
      mode = 'x',
      desc = 'Copy and comment visual selection',
    },
    { '<leader>mp', ':MarkdownPreview<CR>', desc = 'Markdown Preview' },

    -- Telescope
    { '<leader>tt', tu.builtin, desc = 'Telescope: builtin' },
    { '<leader>tk', tu.keymaps, desc = 'Telescope: keymaps' },
    { '<leader>tc', telescope.commands, desc = 'Telescope: commands' },
    { '<leader>tb', tu.buffers, desc = 'Find: buffers' },
    { '<leader>td', telescope.diagnostics, desc = 'Telescope: commands' },
    { '<leader>th', telescope.help_tags, desc = 'Telescope: help tags' },
    { '<leader>tr', telescope.resume, desc = 'Telescope: resume' },
    { '<leader>ta', telescope.autocommands, desc = 'Telescope: autocommands' },

    -- Testing
    { '<leader>xl', '<cmd>:Luapad<CR>', desc = 'Luapad' },
    { '<leader>xd', '<cmd>:e ~/.cache/nvim/nvim-erich.log<CR>', desc = 'Show debug log' },
    { '<leader>xx', '<cmd>:LuaRun<CR>', desc = 'Run current file' },
    { '<leader>xb', require('utils.editor').all_buffers, desc = 'Print buffer info' },
  })
end

return M
