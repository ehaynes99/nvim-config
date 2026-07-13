local function default_branch()
  local out = vim.fn.systemlist('git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null')
  if vim.v.shell_error ~= 0 or #out == 0 then return nil end
  return out[1]:match('refs/remotes/origin/(.+)')
end

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
    { '<leader>gf', function() Snacks.gitbrowse({ branch = default_branch() }) end, mode = { 'n', 'x' }, desc = 'Git: open selected lines in github' },
    { '<leader>gF', function() Snacks.gitbrowse({ what = 'file', branch = default_branch() }) end, mode = { 'n', 'x' }, desc = 'Git: open file in github' },
    { '<leader>wm', function() Snacks.zen() end, desc = 'Toggle zen mode' },
    { '<A-m>', function() Snacks.zen() end, mode = { 'n', 'i' }, desc = 'Toggle zen mode' },
  },
}
