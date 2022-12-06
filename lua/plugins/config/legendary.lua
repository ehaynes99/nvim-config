local legendary = require('legendary')
local editor_utils = require('utils.editor')

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local modes = function(modes)
  local mode_list = {}
  for mode in string.gmatch(modes, '.') do
    table.insert(mode_list, mode)
  end
  return mode_list
end

-- For some reason, mapping to '<ESC> :wincmd h<CR>' doesn't work if a file is empty
local wincmd = function(key)
  return function()
    vim.cmd('stopinsert')
    vim.cmd('wincmd ' .. key)
  end
end

legendary.setup({
  keymaps = {
    { 'jk', '<ESC>', description = 'Leave insert', mode = 'i' },

    -- Find
    { '<leader>fa', ':Legendary<CR>', description = 'Find: keymaps/commands' },
    { '<leader>ff', ':Telescope find_files<CR>', description = 'Find: files' },
    { '<leader>ft', ':Telescope live_grep<CR>', description = 'Find: text' },
    { '<leader>fb', ':Telescope buffers<CR>', description = 'Find: buffers' },
    { '<leader>fs', ':Telescope session-lens search_session<CR>', description = 'Find: sessions' },
    { '<leader>fw', editor_utils.search_tree_dir, description = 'Find: text within tree dir' },

    { '<leader>q', 'q', description = 'Start/stop recording macro' },
    { 'q', '<Nop>' },

    -- Window
    { '<leader>wc', '<cmd>:BDelete this<CR>', description = 'Window: close current buffer' },
    { '<leader>wh', editor_utils.close_hidden_buffers, description = 'Window: close all hidden buffers' },
    { '<S-l>', ':bnext<CR>', description = 'Window: next buffer' },
    { '<S-h>', ':bprevious<CR>', description = 'Window: previous buffer' },
    { '<C-h>', wincmd('h'), description = 'Window: focus left', mode = modes('nivxt') },
    { '<C-j>', wincmd('j'), description = 'Window: focus down', mode = modes('nivxt') },
    { '<C-k>', wincmd('k'), description = 'Window: focus up', mode = modes('nivxt') },
    { '<C-l>', wincmd('l'), description = 'Window: focus right', mode = modes('nivxt') },
    -- { '<C-Up>', ':resize -2<CR>', description = 'Window: resize ' },
    -- { '<C-Down>', ':resize +2<CR>', description = 'Window: resize ' },
    -- { '<C-Left>', ':vertical resize -2<CR>', description = 'Window: resize ' },
    -- { '<C-Right>', ':vertical resize +2<CR>', description = 'Window: 'resize ' },

    -- Debugger
    { '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>", description = 'Debug: toggle breakpoint' },
    { '<leader>dc', "<cmd>lua require('dap').continue()<cr>", description = 'Debug: continue' },
    { '<leader>di', "<cmd>lua require('dap').step_into()<cr>", description = 'Debug: step into' },
    { '<leader>do', "<cmd>lua require('dap').step_over()<cr>", description = 'Debug: step over' },
    { '<leader>dO', "<cmd>lua require('dap').step_out()<cr>", description = 'Debug: step out' },
    { '<leader>dr', "<cmd>lua require('dap').repl.toggle()<cr>", description = 'Debug: repl toggle' },
    { '<leader>dl', "<cmd>lua require('dap').run_last()<cr>", description = 'Debug: run last' },
    { '<leader>du', "<cmd>lua require('dapui').toggle()<cr>", description = 'Debug: ui toggle' },
    { '<leader>dt', "<cmd>lua require('dap').terminate()<cr>", description = 'Debug: terminate' },

    -- Terminal
    { '<ESC><ESC>', '<C-\\><C-n>', description = 'Leave insert', mode = 't' },

    -- Editor
    { '<leader>e', ':NvimTreeToggle<CR>', description = 'Open tree view' },
    { '<leader>n', ':set rnu!<CR>', description = 'Toggle relative line numbers' },
    { '<leader>h', '<cmd>nohlsearch<CR>', description = 'Window: cancel highlight' },
    { 'p', '"_dP', description = 'TODO: black hole paste?', mode = 'v' },
    { '<', '<gv', description = 'Stay in visual mode after indent left', mode = 'v' },
    { '>', '>gv', description = 'Stay in visual mode after indent left', mode = 'v' },

    -- Testing
    { '<leader>xx', '<cmd>:LuaRun<CR>', description = 'Run current file' },
  },
})
