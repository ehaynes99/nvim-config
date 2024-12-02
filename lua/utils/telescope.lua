local telescope = require('telescope.builtin')
local project_utils = require('utils.project')
local git_root = project_utils.git_root
local project_root = project_utils.project_root

local M = {}

local lga = function(args)
  require('telescope').extensions.live_grep_args.live_grep_args(args)
end

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
  telescope.find_files({
    -- doesn't work
    -- search_dirs = { project_root() },
    cwd = project_root(),
    hidden = true,
  })
end

M.live_grep_in_project = function()
  lga({
    -- use this instead of cmd because of https://github.com/BurntSushi/ripgrep/issues/2770
    search_dirs = { project_root() },
    hidden = true,
  })
end

M.live_grep_word_under_cursor_in_project = function()
  require('telescope-live-grep-args.shortcuts').grep_word_under_cursor({
    -- use this instead of cmd because of https://github.com/BurntSushi/ripgrep/issues/2770
    search_dirs = { project_root() },
    hidden = true,
  })
end

M.live_grep_in_project_without_tests = function()
  lga({
    -- use this instead of cmd because of https://github.com/BurntSushi/ripgrep/issues/2770
    search_dirs = { project_root() },
    hidden = true,
    glob_pattern = '!test/**',
  })
end

M.live_grep_without_tests = function()
  lga({
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
  -- git log --pretty="%C(Cyan)%an %C(reset)%ad %s" --date=short
  telescope.git_commits({
    cwd = git_root(),
    -- git_command = 'git log --pretty="%C(reset)%ad %C(Cyan)%an %C(reset)%s" --date=short',
    -- git_command = 'git log --pretty="%C(Cyan)%an %C(reset)%ad %s" --date=short',
  })
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

local create_command_picker = function(commands, prompt_title)
  -- Function to execute the selected command
  local function execute_command(command)
    -- Check if the command requires a selected region
    if command:find('<selected>') then
      -- Get the selected region in the current buffer
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local lines = vim.fn.getline(start_pos[2], end_pos[2])
      local selected_text = table.concat(lines, '\n')

      -- Replace <selected> placeholder with the actual selected text
      command = command:gsub('<selected>', selected_text)
    end

    -- Execute the command
    vim.cmd(command)
  end

  -- Create the picker and store it in a variable
  local picker = telescope.pickers.new({}, {
    prompt_title = prompt_title,
    finder = telescope.finders.new_table({
      results = commands,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    }),
    sorter = telescope.config.values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      -- Define the action on selection
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          execute_command(selection.value)
        end
      end)

      return true
    end,
  })

  -- Return an arity 0 function that calls the find method on the picker
  return function()
    picker:find()
  end
end

return M
