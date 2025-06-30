return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
  },
  config = true,
  keys = {
    {
      '<leader>wr',
      function()
        require('refactoring').select_refactor()
      end,
      mode = 'x',
      desc = 'Refactor: Select',
    },
    { '<leader>we', ':Refactor extract_var ', mode = 'x', desc = 'Refactor: Extract variable' },
    { '<leader>wi', ':Refactor inline_var', mode = {'n', 'x'}, desc = 'Refactor: Inline variable' },
  },
}
