local toggleterm = require('toggleterm')
local Terminal = require('toggleterm.terminal').Terminal
local js_utils = require('utils.javascript')

toggleterm.setup({
  size = 60,
  open_mapping = [[<c-\>]],
  direction = 'float',
  float_opts = {
    border = 'curved',
    width = 180,
  },
})

local gitui_term = Terminal:new({ cmd = 'gitui', hidden = true })

vim.keymap.set('n', '<leader>G', function()
  gitui_term:toggle()
end)

local jest_term = Terminal:new({
  direction = 'vertical',
  size = 90,
  id = 9,
  close_on_exit = true,
  hidden = true,
  -- on_exit = function(terminal, job, exit_code, name)
  --   print('job: ' .. job .. 'exit code: ' .. exit_code .. 'name: ' .. name)
  -- end,
})

vim.keymap.set('n', '<leader>t', function()
  local test_file = vim.api.nvim_buf_get_name(0)
  local project_root = js_utils.project_root(test_file)
  if not project_root then
    print('could not find project root: ' .. test_file)
    return
  end
  local command = 'npx -y --node-options=--inspect jest --watch --no-coverage ' .. test_file

  if jest_term:is_open() then
    jest_term:close()
  else
    jest_term:open()
    jest_term:change_dir(project_root)
    toggleterm.exec(command, 9, 90, project_root)
  end
end)
