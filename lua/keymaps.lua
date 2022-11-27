local defopts = { silent = true }

local map = function(modes, sequence, mapped, opts)
  for mode in string.gmatch(modes, '.') do
    opts = opts or defopts
    vim.keymap.set(mode, sequence, mapped, opts)
  end
end

local unmap = function(sequence)
  vim.keymap.set('', sequence, '<Nop>', defotps)
end

unmap('<Space>')
vim.g.mapleader = ' '

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- 'jk' instead of ESC
map('i', 'jk', '<ESC>')

-- Better window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Resize with arrows
map('n', '<C-Up>', ':resize -2<CR>')
map('n', '<C-Down>', ':resize +2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')

-- Navigate buffers
map('n', '<S-l>', ':bnext<CR>')
map('n', '<S-h>', ':bprevious<CR>')

-- Clear highlights
map('n', '<leader>h', '<cmd>nohlsearch<CR>')

-- Toggle relative line numbers
map('n', '<leader>n', function()
  vim.opt.rnu = not vim.opt.rnu:get()
end)

-- Save and close current buffer
unmap('<C-w>')
map('nivx', '<C-w>', '<cmd>:w|bd<CR>')

-- Better paste
map('v', 'p', '"_dP')

-- Stay in visual mode when indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- NvimTree
-- map('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Telescope
-- map('n', '<leader>ff', ':Telescope find_files<CR>')
-- map('n', '<leader>ft', ':Telescope live_grep<CR>')
-- map('n', '<leader>fp', ':Telescope projects<CR>')
-- map('n', '<leader>fb', ':Telescope buffers<CR>')

-- Git
-- map('n', '<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>')

-- Comment
map('n', '<C-_>', "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>")
map('x', '<C-_>', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
-- map('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
-- map('n', '<leader>dc', "<cmd>lua require'dap'.continue()<cr>")
-- map('n', '<leader>di', "<cmd>lua require'dap'.step_into()<cr>")
-- map('n', '<leader>do', "<cmd>lua require'dap'.step_over()<cr>")
-- map('n', '<leader>dO', "<cmd>lua require'dap'.step_out()<cr>")
-- map('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<cr>")
-- map('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<cr>")
-- map('n', '<leader>du', "<cmd>lua require'dapui'.toggle()<cr>")
-- map('n', '<leader>dt', "<cmd>lua require'dap'.terminate()<cr>")

-- System Clipboard
map('nv', '<leader>p', '"+p')
map('nv', '<leader>P', '"+P')
map('nv', '<leader>y', '"+y')
map('n', '<leader>Y', '"+y$')
