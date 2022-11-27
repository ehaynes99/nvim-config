-- Remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v2.x',
  after = {
    'plenary.nvim',
    'nvim-web-devicons',
    'nui.nvim',
  },
}
