local editor_utils = require('utils.editor')
local lua_utils = require('utils.lua')
local spectre = require('spectre')
local dap = require('dap')
local dapui = require('dapui')
local telescope = require('telescope.builtin')
local tu = require('utils.telescope')

local curry = lua_utils.curry

local modes = function(modes)
  return vim.split(modes, '')
end

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
    local mode = mapping.mode or 'n'
    local key = mapping[1]
    local cmd = mapping[2]
    local opts = vim.tbl_extend('force', { silent = true }, mapping[3] or {})
    vim.keymap.set(mode, key, cmd, opts)
  end
end

M.lsp_keymaps = function(bufnr, lsp_format)
  M.add({
    { 'gD', vim.lsp.buf.declaration, { desc = 'LSP: Goto declaration', buffer = bufnr } },
    { 'gd', telescope.lsp_definitions, { desc = 'LSP: Goto definition', buffer = bufnr } },
    { 'gt', telescope.lsp_type_definitions, { desc = 'LSP: Goto type definition', buffer = bufnr } },
    { 'gi', telescope.lsp_implementations, { desc = 'LSP: Goto implementation', buffer = bufnr } },
    { 'gr', telescope.lsp_references, { desc = 'LSP: Find references', buffer = bufnr } },
    { '<leader>ld', vim.diagnostic.open_float, { desc = 'LSP: Open diagnostics', buffer = bufnr } },
    { '<leader>lf', lsp_format, { desc = 'LSP: Format document', buffer = bufnr } },
    { '<leader>lh', vim.lsp.buf.hover, { desc = 'LSP: Hover tooltip', buffer = bufnr } },
    { '<leader>lx', vim.lsp.buf.code_action, { desc = 'LSP: Code actions native', buffer = bufnr } },
    { '<leader>lp', ':TroubleToggle<CR>', { desc = 'LSP: Trouble window', buffer = bufnr } },
    -- provided by 'weilbith/nvim-code-action-menu' p, buffer = bufnrlugin
    { '<leader>la', ':CodeActionMenu<CR>', { desc = 'LSP: Code actions menu', buffer = bufnr } },
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

M.add({
  { 'jk', '<ESC>', mode = 'i', { desc = 'Leave insert' } },
  { 'Q', '<NOP>', { desc = 'Disable ex mode' } },
  { '<A-h>', ':tabprevious<CR>', mode = modes('nivxt'), { desc = 'Go to previous tab' } },
  { '<A-l>', ':tabnext<CR>', mode = modes('nivxt'), { desc = 'Go to next tab' } },

  -- Find
  { '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find: files' } },
  { '<leader>/', ':Telescope live_grep<CR>', { desc = 'Find: text' } },
  -- { '<leader>fs', ':Telescope session-lens search_session<CR>', { desc = 'Find: sessions' } },
  { '<leader>fs', ':Telescope grep_string<CR>', { desc = 'Find: word under cursor' } },
  { '<leader>fw', editor_utils.search_tree_dir, { desc = 'Find: text within tree dir' } },
  { '<leader>fr', spectre.open_file_search, { desc = 'Find: replace' } },
  { '<leader>fR', spectre.open, { desc = 'Find: global replace' } },
  { '<leader>fr', spectre.open_file_search, mode = modes('vx'), { desc = 'Find: replace' } },
  { '<leader>fR', spectre.open, { desc = 'Find: global replace' } },
  { '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find: Ripgrep' } },

  -- git
  { '<leader>gc', tu.git_commits, { desc = 'Git: show commits' } },
  { '<leader>gh', tu.git_bcommits, { desc = 'Git: file history' } },
  { '<leader>gB', tu.git_branches, { desc = 'Git: branches' } },
  { '<leader>gb', ':BlamerToggle<CR>', { desc = 'Git: show blame' } },
  { '<Leader>gf', ':OpenInGHFile <CR>', { desc = 'Git: open file in github' } },

  -- macros
  { '<leader>q', 'q', { desc = 'Start/stop recording macro' } },
  { 'q', '<Nop>' },

  -- text
  { 'J', 'mzJ`z', { desc = 'Join lines' } }, -- keep cursor where it started
  { '<leader>cp', '"+p', { desc = 'Paste from clipboard' } },
  { '<leader>cP', '"+P', { desc = 'Paste from clipboard above' } },
  { '<leader>cy', '"+y', mode = { 'n', 'v' }, { desc = 'Yank to cliboard' } },
  { '<leader>cd', '"+d', mode = { 'n', 'v' }, { desc = 'Delete to cliboard' } },
  { '<leader>cY', '"+Y', { desc = 'Yank line to cliboard' } },
  { 'Y', 'yg$', { desc = 'Yank to end of line' } },
  { 'J', ":m '>+1<CR>gv=gv", mode = 'v', { desc = 'Move lines down' } },
  { 'K', ":m '<-2<CR>gv=gv", mode = 'v', { desc = 'Move lines up' } },
  {
    '<leader>r',
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = 'Global replace word under cursor' },
  },
  {
    '<leader>r',
    [["hy:%s/<C-r>h//gI<left><left><left>]],
    mode = 'v',
    { desc = 'Global replace word under cursor' },
  },

  -- Window
  { '<leader>wc', '<cmd>:BDelete this<CR>', { desc = 'Window: close current buffer' } },
  { '<leader>wh', editor_utils.close_hidden_buffers, { desc = 'Window: close all hidden buffers' } },
  { '<S-l>', ':bnext<CR>', { desc = 'Window: next buffer' } },
  { '<S-h>', ':bprevious<CR>', { desc = 'Window: previous buffer' } },
  { '<C-h>', wincmd('h'), mode = modes('nivxt'), { desc = 'Window: focus left' } },
  { '<C-j>', wincmd('j'), mode = modes('nivxt'), { desc = 'Window: focus down' } },
  { '<C-k>', wincmd('k'), mode = modes('nivxt'), { desc = 'Window: focus up' } },
  { '<C-l>', wincmd('l'), mode = modes('nivxt'), { desc = 'Window: focus right' } },
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
  { '<leader>e', ':NvimTreeFocus<CR>', { desc = 'Focus tree view' } },
  { '<leader>E', ':NvimTreeToggle<CR>', { desc = 'Open tree view' } },
  { '<leader>n', ':set rnu!<CR>', { desc = 'Toggle relative line numbers' } },
  { '<leader>h', ':nohlsearch<CR>', { desc = 'Window: cancel highlight' } },
  { '<C-P>', '"_dP', mode = 'v', { desc = 'Paste without copying replaced' } },
  { '<', '<gv', mode = 'v', { desc = 'Stay in visual mode after indent left' } },
  { '>', '>gv', mode = 'v', { desc = 'Stay in visual mode after indent left' } },
  -- '<C-_>' is magic syntax for <C-/> because you can't map the slash character
  { '<C-_>', require('Comment.api').toggle.linewise.current, mode = { 'n', 'i' }, { desc = 'Comment toggle' } },
  {
    '<C-_>',
    function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())
    end,
    mode = { 'x', 'v' },
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
  { '<leader>xx', '<cmd>:LuaRun<CR>', { desc = 'Run current file' } },
  { '<leader>xb', require('utils.editor').all_buffers, { desc = 'Print buffer info' } },
})

return M
