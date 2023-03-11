return {
  'Saecki/crates.nvim',
  version = '^0.3.0',
  event = 'BufRead Cargo.toml',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('crates').setup({
      null_ls = {
        enabled = true,
      },
    })
  end,
}
