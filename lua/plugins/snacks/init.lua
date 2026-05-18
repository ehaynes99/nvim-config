return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    indent = { indent = { char = '▏' }, scope = { enabled = true, char = '▏' } },
    zen = { win = { width = 0.9, backdrop = { blend = 90 } } },
  },
  keys = {
    { '<leader>gf', function() Snacks.gitbrowse() end, mode = { 'n', 'x' }, desc = 'Git: open selected lines in github' },
    { '<leader>gF', function() Snacks.gitbrowse({ what = 'file' }) end, mode = { 'n', 'x' }, desc = 'Git: open file in github' },
    { '<leader>wm', function() Snacks.zen() end, desc = 'Toggle zen mode' },
    { '<A-m>', function() Snacks.zen() end, mode = { 'n', 'i' }, desc = 'Toggle zen mode' },
  },
}
