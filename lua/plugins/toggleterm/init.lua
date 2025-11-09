return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  config = function()
    local toggleterm = require('toggleterm')
    local Terminal = require('toggleterm.terminal').Terminal

    -- Import terminal modules
    local gitui = require('plugins.toggleterm.terminals.gitui')
    local test = require('plugins.toggleterm.terminals.test')
    local side = require('plugins.toggleterm.terminals.side')
    local tsx = require('plugins.toggleterm.terminals.tsx')

    -- Base configuration
    toggleterm.setup({
      size = 100, -- this affects the vertical buffers
      open_mapping = [[<c-\>]],
      direction = 'float',
      float_opts = {
        border = 'rounded',
        width = 240,
      },
    })

    -- Initialize terminal modules
    local gitui_module = gitui(Terminal)
    local test_module = test(Terminal)
    local side_module = side(Terminal)
    local tsx_module = tsx(Terminal)

    -- Register keymaps
    vim.keymap.set('n', '<leader>G', gitui_module.toggle, { desc = 'Toggle gitui' })
    vim.keymap.set('n', '<leader>T', test_module.run)
    vim.keymap.set('n', '<leader><BS>', side_module.toggle, { desc = 'Toggle side terminal' })
    vim.keymap.set('n', '<leader>X', tsx_module.execute, { desc = 'Run file with ts_node' })
  end,
}
