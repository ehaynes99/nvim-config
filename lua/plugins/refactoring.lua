return {
  'ThePrimeagen/refactoring.nvim',
  lazy = false,
  dependencies = {
    { 'lewis6991/async.nvim' },
  },
  keys = {
    {
      '<leader>wr',
      function()
        require('refactoring').select_refactor()
      end,
      mode = 'x',
      desc = 'Refactor: Select',
    },
    {
      '<leader>we',
      function()
        return require('refactoring').extract_var()
      end,
      expr = true,
      mode = 'x',
      desc = 'Refactor: Extract variable',
    },
    {
      '<leader>wi',
      function()
        return require('refactoring').inline_var()
      end,
      expr = true,
      mode = { 'n', 'x' },
      desc = 'Refactor: Inline variable',
    },
  },
}
