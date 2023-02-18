return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  config = function()
    local toggleterm = require('toggleterm')
    local Terminal = require('toggleterm.terminal').Terminal
    local project_utils = require('utils.project')

    toggleterm.setup({
      size = 80, -- this affects the vertical buffers
      open_mapping = [[<c-\>]],
      direction = 'float',
      float_opts = {
        border = 'rounded',
        width = 240,
      },
    })

    local close_if_successful = function(term, _, exit_code)
      if exit_code == 0 then
        term:close()
        if vim.api.nvim_buf_is_loaded(term.bufnr) then
          vim.api.nvim_buf_delete(term.bufnr, { force = true })
        end
      end
    end

    local gitui_term = Terminal:new({
      hidden = true,
      close_on_exit = false,
      float_opts = {
        border = 'rounded',
      },
      on_exit = close_if_successful,
    })

    vim.keymap.set('n', '<leader>G', function()
      local git_root = project_utils.git_root() or vim.fn.getcwd()

      gitui_term.cmd = 'gitui -d ' .. git_root
      gitui_term:toggle()
    end, { desc = 'Toggle gitui' })

    local jest_term = Terminal:new({
      direction = 'vertical',
      close_on_exit = false,
      hidden = true,
      on_exit = close_if_successful,
    })

    vim.keymap.set('n', '<leader>T', function()
      local test_file = vim.api.nvim_buf_get_name(0)

      local project_root = project_utils.project_root(test_file)

      if not project_root then
        print('could not find project root: ' .. test_file)
        return
      end

      print('project_root: ' .. project_root)
      local cmd = 'npx -y --node-options=--inspect jest --watch --no-coverage ' .. test_file

      if jest_term:is_open() then
        jest_term:change_dir(project_root)
      else
        jest_term.dir = project_root
      end
      jest_term.cmd = cmd
      jest_term:toggle(90)
    end)

    local side_term = Terminal:new({
      direction = 'vertical',
      close_on_exit = true,
      hidden = true,
    })

    vim.keymap.set('n', '<leader><BS>', function()
      if side_term:is_open() and not side_term:is_focused() then
        side_term:focus()
      else
        side_term:toggle()
      end
    end)
  end,
}
