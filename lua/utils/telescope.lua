local telescope = require('telescope.builtin')
local git_root = require('utils.project').git_root

local M = {}

M.buffers = function()
  telescope.buffers({ ignore_current_buffer = true })
end

M.builtin = function()
  telescope.builtin({ include_extends = true, use_default_opts = true })
end

M.keymaps = function()
  telescope.keymaps({ modes = { 'n', 'i', 'v', 'x', 't' } })
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
