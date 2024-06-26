local telescope = require('telescope.builtin')
local project_utils = require('utils.project')
local git_root = project_utils.git_root
local project_root = project_utils.project_root

local M = {}

M.buffers = function()
  telescope.buffers({
    sort_mru = true,
  })
end

M.builtin = function()
  telescope.builtin({ include_extends = true, use_default_opts = true })
end

M.keymaps = function()
  telescope.keymaps({ modes = { 'n', 'i', 'v', 'x', 't' } })
end

M.find_files = function()
  telescope.find_files({ hidden = true })
end

M.find_files_in_project = function()
  telescope.find_files({ cwd = project_root(), hidden = true })
end

M.live_grep_in_project = function()
  telescope.live_grep({ cwd = project_root(), hidden = true })
end

M.live_grep_in_project_without_tests = function()
  telescope.live_grep({
    cwd = project_root(),
    hidden = true,
    glob_pattern = '!test/**',
  })
end

M.live_grep_without_tests = function()
  telescope.live_grep({
    cwd = git_root(),
    hidden = true,
    glob_pattern = '!test/**',
  })
end

M.git_bcommits = function()
  telescope.git_bcommits({ cwd = git_root() })
end

M.git_branches = function()
  telescope.git_branches({ cwd = git_root() })
end

M.git_commits = function()
  telescope.git_commits({ cwd = git_root() })
end

M.git_files = function()
  telescope.git_files({ cwd = git_root() })
end

M.git_stash = function()
  telescope.git_stash({ cwd = git_root() })
end

M.git_status = function()
  telescope.git_status({ cwd = git_root() })
end

return M
