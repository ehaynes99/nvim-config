return {
  'akinsho/toggleterm.nvim',
  event = 'VeryLazy',
  config = function()
    local toggleterm = require('toggleterm')
    local Terminal = require('toggleterm.terminal').Terminal
    local project_utils = require('utils.project')

    toggleterm.setup({
      size = 100, -- this affects the vertical buffers
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
      on_open = function(term)
        vim.keymap.set('t', '<ESC>', '<ESC>', { buffer = term.bufnr, nowait = true })
      end,
    })

    vim.keymap.set('n', '<leader>G', function()
      local git_root = project_utils.git_root() or vim.fn.getcwd()

      gitui_term.cmd = 'gitui -d ' .. git_root
      gitui_term:toggle()
    end, { desc = 'Toggle gitui' })

    local test_term = Terminal:new({
      direction = 'vertical',
      close_on_exit = true,
      hidden = true,
      on_exit = close_if_successful,
      -- on_create = function(term)
      --   vim.keymap.set('n', 'q', function()
      --     print('should be quitting now')
      --     toggleterm.send_lines_to_terminal('q', false, { args = term.id })
      --   end, { buffer = term.bufnr, desc = 'Close terminal' })
      -- end,
    })

    vim.keymap.set('n', '<leader>T', function()
      local test_file = vim.api.nvim_buf_get_name(0)

      local project_root = project_utils.project_root(test_file)

      if not project_root then
        print('could not find project root: ' .. test_file)
        return
      end

      -- local cmd = 'node_modules/jest/bin/jest.js --reporters="default" --watch --no-coverage --runInBand ' .. test_file
      --
      -- if project_utils.is_module(test_file) then
      --   cmd = 'NODE_OPTIONS="--experimental-vm-modules" ' .. cmd
      -- end

      -- local cmd = 'pnpm test --watch --disableConsoleIntercept ' .. test_file
      local cmd = 'pnpx vitest --watch --disableConsoleIntercept ' .. test_file


      print('project root: ' .. project_root)
      print('test file: ' .. test_file)
      print('cmd: ' .. cmd)

      if test_term:is_open() then
        test_term:change_dir(project_root)
      else
        test_term.dir = project_root
      end
      test_term.cmd = cmd
      test_term:toggle()
    end)

    local toggle_sideterm

    local side_term = Terminal:new({
      direction = 'vertical',
      close_on_exit = true,
      hidden = true,
      -- CAUSES DELAY ON SPACEBAR
      -- on_open = function(term)
      --   vim.keymap.set('t', '<leader><BS>', toggle_sideterm, { buffer = term.bufnr, desc = 'Toggle side terminal' })
      -- end,
    })

    toggle_sideterm = function()
      if side_term:is_open() and not side_term:is_focused() then
        side_term:focus()
      else
        side_term:toggle()
      end
    end

    vim.keymap.set('n', '<leader><BS>', toggle_sideterm, { desc = 'Toggle side terminal' })

    local ts_node_term = Terminal:new({
      direction = 'vertical',
      close_on_exit = true,
      hidden = true,
      -- close_on_exit = false,
      -- on_exit = close_if_successful,
    })
    local execute_ts_node = function()
      local file = vim.api.nvim_buf_get_name(0)
      local project_root = project_utils.project_root(file)

      if not project_root then
        print('could not find project root: ' .. file)
        return
      end

      -- local cmd = 'npx -y nodemon --watch ' .. file .. ' --exec "ts-node ' .. file .. '"'
      -- local cmd = 'npx -y ts-node-dev ' .. file
      -- local cmd = 'npx -y esbuild-runner ' .. file
      -- local cmd = 'npx -y tsx watch ' .. file
      local cmd = 'pnpx tsx watch ' .. file

      if ts_node_term:is_open() then
        ts_node_term:change_dir(project_root)
      else
        ts_node_term.dir = project_root
      end
      ts_node_term.cmd = cmd
      ts_node_term:toggle()
    end
    vim.keymap.set('n', '<leader>x', execute_ts_node, { desc = 'Run file with ts_node' })
  end,
}
