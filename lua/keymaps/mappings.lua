local editor_utils = require('utils.editor')
local lua_utils = require('utils.lua')
local mapper = require('keymaps.mapper')
local spectre = require('spectre')
local dap = require('dap')
local dapui = require('dapui')

local curry = lua_utils.curry

-- For some reason, mapping to '<ESC> :wincmd h<CR>' doesn't work if a file is empty
local wincmd = function(key)
  return function()
    vim.cmd('stopinsert')
    vim.cmd('wincmd ' .. key)
  end
end
-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

local M = {}

M.standard_keymaps = function()
  mapper.add({
    { 'jk', '<ESC>', desc = 'Leave insert', mode = 'i' },

    -- Find
    { '<leader>fa', ':Legendary<CR>', desc = 'Find: keymaps/commands' },
    { '<leader>ff', ':Telescope find_files<CR>', desc = 'Find: files' },
    { '<leader>ft', ':Telescope live_grep<CR>', desc = 'Find: text' },
    { '<leader>fb', ':Telescope buffers<CR>', desc = 'Find: buffers' },
    { '<leader>fs', ':Telescope session-lens search_session<CR>', desc = 'Find: sessions' },
    { '<leader>fw', editor_utils.search_tree_dir, desc = 'Find: text within tree dir' },
    { '<leader>fr', spectre.open_file_search, desc = 'Find: replace' },
    { '<leader>fR', spectre.open, desc = 'Find: global replace' },
    { '<leader>fr', spectre.open_file_search, desc = 'Find: replace', mode = 'vx' },
    { '<leader>fR', spectre.open, desc = 'Find: global replace' },

    -- macros
    { '<leader>q', 'q', desc = 'Start/stop recording macro' },
    { 'q', '<Nop>' },

    -- Window
    { '<leader>wc', '<cmd>:BDelete this<CR>', desc = 'Window: close current buffer' },
    { '<leader>wh', editor_utils.close_hidden_buffers, desc = 'Window: close all hidden buffers' },
    { '<S-l>', ':bnext<CR>', desc = 'Window: next buffer' },
    { '<S-h>', ':bprevious<CR>', desc = 'Window: previous buffer' },
    { '<C-h>', wincmd('h'), desc = 'Window: focus left', mode = 'nivxt' },
    { '<C-j>', wincmd('j'), desc = 'Window: focus down', mode = 'nivxt' },
    { '<C-k>', wincmd('k'), desc = 'Window: focus up', mode = 'nivxt' },
    { '<C-l>', wincmd('l'), desc = 'Window: focus right', mode = 'nivxt' },
    -- { '<C-Up>', ':resize -2<CR>', desc = 'Window: resize ' },
    -- { '<C-Down>', ':resize +2<CR>', desc = 'Window: resize ' },
    -- { '<C-Left>', ':vertical resize -2<CR>', desc = 'Window: resize ' },
    -- { '<C-Right>', ':vertical resize +2<CR>', desc = 'Window: 'resize ' },

    -- LSP - most of these are set up in on_attach in lsp settings, but these aren't buffer specific
    { '<leader>li', ':LspInfo<CR>', desc = 'LSP: LSP info for file' },
    { '<leader>lI', ':Mason<CR>', desc = 'LSP: Install servers' },

    -- Debugger
    { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: toggle breakpoint' },
    { '<leader>dc', dap.continue, desc = 'Debug: continue' },
    { '<leader>di', dap.step_into, desc = 'Debug: step into' },
    { '<leader>do', dap.step_over, desc = 'Debug: step over' },
    { '<leader>dO', dap.step_out, desc = 'Debug: step out' },
    { '<leader>dr', dap.repl.toggle, desc = 'Debug: repl toggle' },
    { '<leader>dl', dap.run_last, desc = 'Debug: run last' },
    { '<leader>du', dapui.toggle, desc = 'Debug: ui toggle' },
    { '<leader>dt', dap.terminate, desc = 'Debug: terminate' },

    -- Terminal
    { '<ESC><ESC>', '<C-\\><C-n>', desc = 'Leave insert', mode = 't' },

    -- Editor
    { '<leader>e', ':NvimTreeToggle<CR>', desc = 'Open tree view' },
    { '<leader>n', ':set rnu!<CR>', desc = 'Toggle relative line numbers' },
    { '<leader>h', ':nohlsearch<CR>', desc = 'Window: cancel highlight' },
    { 'p', '"_dP', desc = 'Paste without copying replaced', mode = 'v' },
    { '<', '<gv', desc = 'Stay in visual mode after indent left', mode = 'v' },
    { '>', '>gv', desc = 'Stay in visual mode after indent left', mode = 'v' },

    -- Testing
    { '<leader>xx', '<cmd>:LuaRun<CR>', desc = 'Run current file' },
  })
end

M.lsp_keymaps = function(bufnr)
  mapper.add({ buffer = bufnr }, {
    { 'gD', vim.lsp.buf.declaration, desc = 'LSP: Goto declaration' },
    { 'gd', vim.lsp.buf.definition, desc = 'LSP: Goto definition' },
    { 'gt', vim.lsp.buf.type_definition, desc = 'LSP: Goto type definition' },
    { 'gI', vim.lsp.buf.implementation, desc = 'LSP: Goto implementation' },
    { 'gr', vim.lsp.buf.references, desc = 'LSP: Find references' },
    { '<leader>ld', vim.diagnostic.open_float, desc = 'LSP: Open diagnostics' },
    { '<leader>lf', curry(vim.lsp.buf.format)({ async = true }), desc = 'LSP: Format document' },
    { '<leader>lh', vim.lsp.buf.hover, desc = 'LSP: Hover tooltip' },
    { '<leader>lx', vim.lsp.buf.code_action, desc = 'LSP: Code actions native' },
    -- provided by 'weilbith/nvim-code-action-menu' plugin
    { '<leader>la', ':CodeActionMenu<CR>', desc = 'LSP: Code actions menu' },
    { '<leader>lj', curry(vim.diagnostic.goto_next)({ buffer = 0 }), desc = 'LSP: Next diagnostic' },
    { '<leader>lk', curry(vim.diagnostic.goto_prev)({ buffer = 0 }), desc = 'LSP: Previous diagnostic' },
    { '<leader>lr', vim.lsp.buf.rename, desc = 'LSP: Rename' },
    { '<leader>ls', vim.lsp.buf.signature_help, desc = 'LSP: Signature help' },
    { '<leader>lq', vim.diagnostic.setloclist, desc = 'LSP: Set loclist' },
  })
end

return M