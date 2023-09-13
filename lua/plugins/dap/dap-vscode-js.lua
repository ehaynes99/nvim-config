local M = {}

M.setup = function()
  local dap = require('dap')

  require('dap-vscode-js').setup({
    debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
  })

  for _, language in ipairs({ 'typescript', 'javascript' }) do
    dap.configurations[language] = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'ts-node current file DAP',
        runtimeExecutable = 'npx',
        runtimeArgs = { '-y', 'ts-node' },
        program = '${file}',
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        console = 'integratedTerminal',
        internalConsoleOptions = 'neverOpen',
      },
      -- {
      --   type = 'pwa-node',
      --   request = 'launch',
      --   name = 'Debug Jest Tests',
      --   -- trace = true, -- include debugger info
      --   runtimeExecutable = 'node',
      --   runtimeArgs = {
      --     './node_modules/jest/bin/jest.js',
      --     '--runInBand',
      --   },
      --   rootPath = '${workspaceFolder}',
      --   cwd = '${workspaceFolder}',
      --   console = 'integratedTerminal',
      --   internalConsoleOptions = 'neverOpen',
      -- },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Debug Jest Tests',
        -- trace = true, -- include debugger info
        runtimeExecutable = 'npx',
        runtimeArgs = {
          'jest',
          '--runInBand',
          '--watch',
        },
        rootPath = '${workspaceFolder}',
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        internalConsoleOptions = 'neverOpen',
      },
      -- {
      --   type = 'pwa-node',
      --   request = 'launch',
      --   name = 'watch current file',
      --   runtimeExecutable = 'npx',
      --   runtimeArgs = {
      --     '-y',
      --     'nodemon',
      --     '-q',
      --     '--exec',
      --     'npx',
      --     '-y',
      --     'ts-node',
      --   },
      --   program = '${file}',
      --   cwd = '${workspaceFolder}',
      --   restart = true,
      --   console = 'integratedTerminal',
      --   internalConsoleOptions = 'neverOpen',
      -- },
    }
  end
end

return M
