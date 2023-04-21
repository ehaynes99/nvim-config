local keymaps = require('keymaps')
local curry = require('utils.lua').curry

return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
  },
  config = function()
    local refactoring = require('refactoring')
    refactoring.setup({})

    keymaps.add({
      { '<leader>wr', refactoring.select_refactor, mode = 'x', desc = 'Refactor: Select' },
      {
        '<leader>we',
        curry(refactoring.refactor)('Extract Variable'),
        mode = 'v',
        desc = 'Refactor: Extract variable',
      },
      {
        '<leader>wi',
        function()
          refactoring.refactor('Inline Variable')
          -- leave visual mode
          local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
          vim.api.nvim_feedkeys(esc, 'x', false)
        end,
        mode = 'v',
        desc = 'Refactor: Inline variable',
      },
    })
  end,
}
