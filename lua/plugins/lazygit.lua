-- lazygit.nvim passes GIT_DIR/GIT_WORK_TREE as -g/-w when both are set, so
-- exposing them just for the duration of the call points it at the dotfiles repo.
local function open()
  local project_dir = require('utils.project').git_root() or vim.fn.getcwd()
  local repo = require('utils.dotfiles').repo_for(project_dir)
  if repo then
    vim.env.GIT_DIR = repo.git_dir
    vim.env.GIT_WORK_TREE = repo.work_tree
  end
  vim.cmd.LazyGit()
  if repo then
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
  end
end

return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>gg', open, desc = 'LazyGit' },
  },
}
