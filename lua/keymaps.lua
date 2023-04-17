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
    local mode
    if mapping.mode == nil then
      mode = { 'n' }
    elseif type(mapping.mode) == 'string' then
      ---@diagnostic disable-next-line: missing-parameter
      mode = vim.split(mapping.mode, '')
    else
      mode = mapping.mode
    end

    local key = mapping[1]
    local cmd = mapping[2]
    local opts = vim.tbl_extend('force', { silent = true }, mapping[3] or {})
    vim.keymap.set(mode, key, cmd, opts)
  end
end

M.lsp_keymaps = function(bufnr, lsp_format)
  local telescope = require('telescope.builtin')
  if lsp_format then
    M.add({
      { '<leader>lf', lsp_format, { desc = 'LSP: Format document', buffer = bufnr } },
    })
  end
  M.add({
    { 'gD', vim.lsp.buf.declaration, { desc = 'LSP: Goto declaration', buffer = bufnr } },
    { 'gd', telescope.lsp_definitions, { desc = 'LSP: Goto definition', buffer = bufnr } },
    { 'gt', telescope.lsp_type_definitions, { desc = 'LSP: Goto type definition', buffer = bufnr } },
    { 'gi', telescope.lsp_implementations, { desc = 'LSP: Goto implementation', buffer = bufnr } },
    { 'gr', telescope.lsp_references, { desc = 'LSP: Find references', buffer = bufnr } },
    { 'gR', vim.lsp.buf.references, { desc = 'LSP: Find references', buffer = bufnr } },
    { '<leader>ld', vim.diagnostic.open_float, { desc = 'LSP: Open diagnostics', buffer = bufnr } },
    { '<leader>lh', vim.lsp.buf.hover, { desc = 'LSP: Hover tooltip', buffer = bufnr } },
    { '<leader>la', vim.lsp.buf.code_action, { desc = 'LSP: Code actions native', buffer = bufnr } },
    { '<leader>lp', ':TroubleToggle<CR>', { desc = 'LSP: Trouble window', buffer = bufnr } },
    {
      '<leader>lj',
      curry(vim.diagnostic.goto_next)({ buffer = 0 }),
      { desc = 'LSP: Next diagnostic', buffer = bufnr },
    },
    {
      '<leader>lk',
      curry(vim.diagnostic.goto_prev)({ buffer = 0 }),
      { desc = 'LSP: Previous diagnostic', buffer = bufnr },
    },
    { '<leader>lr', vim.lsp.buf.rename, { desc = 'LSP: Rename', buffer = bufnr } },
    { '<leader>ls', vim.lsp.buf.signature_help, { desc = 'LSP: Signature help', buffer = bufnr } },
    { '<leader>lq', vim.diagnostic.setloclist, { desc = 'LSP: Set loclist', buffer = bufnr } },
  })
end

M.init = function()
  local spectre = require('spectre')
  local dap = require('dap')
  local dapui = require('dapui')
  local telescope = require('telescope.builtin')
  local tu = require('utils.telescope')
  M.add({
    { 'jk', '<ESC>', mode = 'i', { desc = 'Leave insert' } },
    { 'Q', '<NOP>', { desc = 'Disable ex mode' } },
    { '<A-h>', ':tabprevious<CR>', mode = 'nixt', { desc = 'Go to previous tab' } },
    { '<A-l>', ':tabnext<CR>', mode = 'nixt', { desc = 'Go to next tab' } },

    -- Find
    { '<leader>ff', tu.find_files, { desc = 'Find: files' } },
    { '<leader>/', ':Telescope live_grep<CR>', { desc = 'Find: text' } },
    -- { '<leader>fs', ':Telescope session-lens search_session<CR>', { desc = 'Find: sessions' } },
    { '<leader>fs', ':Telescope grep_string<CR>', { desc = 'Find: word under cursor' } },
    { '<leader>fp', tu.live_grep_in_project, { desc = 'Find: text in project' } },

    { '<leader>fw', editor_utils.search_tree_dir, { desc = 'Find: text within tree dir' } },
    { '<leader>fr', spectre.open_file_search, { desc = 'Spectre: Find replace' } },
    { '<leader>fR', spectre.open, { desc = 'Spectre: Global find replace' } },
    { '<leader>fr', spectre.open_file_search, mode = 'vx', { desc = 'Spectre: Find replace' } },
    { '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find: Ripgrep' } },

    -- git
    { '<leader>gc', tu.git_commits, { desc = 'Git: show commits' } },
    { '<leader>gh', tu.git_bcommits, { desc = 'Git: show commits for file' } },
    { '<leader>gB', tu.git_branches, { desc = 'Git: branches' } },
    { '<leader>gb', ':BlamerToggle<CR>', { desc = 'Git: show blame' } },
    { '<Leader>gf', ':OpenInGHFile <CR>', { desc = 'Git: open file in github' } },

    -- macros
    { '<leader>q', 'q', { desc = 'Start/stop recording macro' } },
    { 'q', '<Nop>' },

    -- text
    { '<C-J>', 'mzJ`z', { desc = 'Join lines & preserve cursor' } },
    -- { '<leader>cp', '"+p', mode = 'nx', { desc = 'Paste from clipboard' } },
    -- { '<leader>cP', '"+P', { desc = 'Paste from clipboard above' } },
    -- { '<leader>cy', '"+y', mode = 'nx', { desc = 'Yank to cliboard' } },
    -- { '<leader>cd', '"+d', mode = 'nx', { desc = 'Delete to cliboard' } },
    { '<leader>vw', 'ggVG', { desc = 'Select all' } },
    { 'Y', 'y$', { desc = 'Yank to end of line' } },
    { 'J', ":m '>+1<CR>gv=gv", mode = 'x', { desc = 'Move lines down' } },
    { 'K', ":m '<-2<CR>gv=gv", mode = 'x', { desc = 'Move lines up' } },
    { 'j', "v:count ? 'j' : 'gj'", mode = 'nx', { desc = 'Move cursor up', expr = true } },
    { 'k', "v:count ? 'k' : 'gk'", mode = 'nx', { desc = 'Move cursor down', expr = true } },
    { '<Down>', "v:count ? 'j' : 'gj'", mode = 'nx', { desc = 'Move cursor up', expr = true } },
    { '<Up>', "v:count ? 'k' : 'gk'", mode = 'nx', { desc = 'Move cursor down', expr = true } },
    { '<leader>ww', ':setl wrap!<CR>', { desc = 'Toggle soft wrap' } },
    { '<leader>wu', ':UndotreeToggle<CR>', { desc = 'Toggle soft wrap' } },
    {
      '<leader>r',
      ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
      { desc = 'Global replace word under cursor', silent = false },
    },
    {
      '<leader>r',
      [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
      { desc = 'Replace word under cursor', silent = false },
    },
    {
      '<leader>r',
      [["hy:%s/<C-r>h//gI<left><left><left>]],
      mode = 'x',
      { desc = 'Replace selected text', silent = false },
    },

    -- Window
    { '<leader>wc', '<cmd>:BDelete this<CR>', { desc = 'Window: close current buffer' } },
    { '<leader>wh', editor_utils.close_hidden_buffers, { desc = 'Window: close all hidden buffers' } },
    { '<leader>wo', ':SymbolsOutline<CR>', { desc = 'Toggle symbols outline' } },
    { '<leader>wx', '<cmd>!chmod +x %<CR>', { desc = 'Toggle file executable' } },

    { '<LeftDrag>', '', { desc = 'Disable left drag' } },
    { '<LeftRelease>', '', { desc = 'Disable left drag' } },
    { '<RightDrag>', '', { desc = 'Disable right drag' } },
    { '<RightRelease>', '', { desc = 'Disable right drag' } },
    { '<S-l>', ':bnext<CR>', { desc = 'Window: next buffer' } },
    { '<S-h>', ':bprevious<CR>', { desc = 'Window: previous buffer' } },
    { '<C-h>', wincmd('h'), mode = 'nixt', { desc = 'Window: focus left' } },
    { '<C-j>', wincmd('j'), mode = 'nixt', { desc = 'Window: focus down' } },
    { '<C-k>', wincmd('k'), mode = 'nixt', { desc = 'Window: focus up' } },
    { '<C-l>', wincmd('l'), mode = 'nixt', { desc = 'Window: focus right' } },
    -- { '<C-Up>', ':resize -2<CR>', { desc = 'Window: resize ' } },
    -- { '<C-Down>', ':resize +2<CR>', { desc = 'Window: resize ' } },
    -- { '<C-Left>', ':vertical resize -2<CR>', { desc = 'Window: resize ' } },
    -- { '<C-Right>', ':vertical resize +2<CR>', { desc = 'Window: ' }resize ' },

    -- Various plugin info
    -- { '<leader>pl', ':LspInfo<CR>', { desc = 'LSP: LSP info for file' } },
    -- { '<leader>pm', ':Mason<CR>', { desc = 'LSP: Install servers' } },
    -- { '<leader>pn', ':NullLsInfo<CR>', { desc = 'LSP: Null-ls info for file' } },

    -- Debugger
    { '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: toggle breakpoint' } },
    { '<leader>dc', dap.continue, { desc = 'Debug: continue' } },
    { '<leader>di', dap.step_into, { desc = 'Debug: step into' } },
    { '<leader>do', dap.step_over, { desc = 'Debug: step over' } },
    { '<leader>dO', dap.step_out, { desc = 'Debug: step out' } },
    { '<leader>dr', dap.repl.toggle, { desc = 'Debug: repl toggle' } },
    { '<leader>dl', dap.run_last, { desc = 'Debug: run last' } },
    { '<leader>du', dapui.toggle, { desc = 'Debug: ui toggle' } },
    { '<leader>dt', dap.terminate, { desc = 'Debug: terminate' } },

    -- Terminal
    { '<ESC><ESC>', '<C-\\><C-n>', mode = 't', { desc = 'Leave insert' } },

    -- Editor
    { '<leader>n', ':set rnu!<CR>', { desc = 'Toggle relative line numbers' } },
    { '<leader>h', ':nohlsearch<CR>', { desc = 'Window: cancel highlight' } },
    { 'p', '"_dP', mode = 'x', { desc = 'Paste without copying replaced' } },
    { '<C-p>', 'p', mode = 'x', { desc = 'Paste and yank' } },
    { '<', '<gv', mode = 'x', { desc = 'Stay in visual mode after indent left' } },
    { '>', '>gv', mode = 'x', { desc = 'Stay in visual mode after indent left' } },
    -- '<C-_>' is magic syntax for <C-/> because you can't map the slash character
    { '<C-_>', require('Comment.api').toggle.linewise.current, mode = 'ni', { desc = 'Comment toggle' } },
    {
      '<C-_>',
      function()
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'nx', false)
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end,
      mode = 'x',
      { desc = 'Comment toggle' },
    },

    -- Telescope/legendary
    { '<leader>tt', tu.builtin, desc = 'Telescope: builtin' },
    { '<leader>tk', tu.keymaps, desc = 'Telescope: keymaps' },
    { '<leader>tK', ':Legendary keymaps<CR>', desc = 'Legendary: keymaps' },
    { '<leader>tc', telescope.commands, desc = 'Telescope: commands' },
    { '<leader>tC', ':Legendary commands<CR>', desc = 'Legendary: commands' },
    { '<leader>tA', ':Legendary<CR>', desc = 'Legendary: search all' },
    { '<leader>tb', tu.buffers, { desc = 'Find: buffers' } },
    { '<leader>td', telescope.diagnostics, { desc = 'Telescope: commands' } },
    { '<leader>th', telescope.help_tags, { desc = 'Telescope: help tags' } },
    { '<leader>tr', telescope.resume, { desc = 'Telescope: resume' } },
    { '<leader>ta', telescope.autocommands, { desc = 'Telescope: autocommands' } },

    -- Testing
    { '<leader>xl', '<cmd>:Luapad<CR>', { desc = 'Luapad' } },
    { '<leader>xd', '<cmd>:e ~/.cache/nvim/nvim-erich.log<CR>', { desc = 'Show debug log' } },
    { '<leader>xx', '<cmd>:LuaRun<CR>', { desc = 'Run current file' } },
    { '<leader>xb', require('utils.editor').all_buffers, { desc = 'Print buffer info' } },
  })
end

return M
