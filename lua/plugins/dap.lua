return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      version = '1.x',
      build = 'rm -rf out/dist && npm i && npm run compile vsDebugServerBundle && mv dist out',
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local keymaps = require('keymaps')

    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '@exception' })
    vim.fn.sign_define(
      'DapBreakpointCondition',
      { text = 'ﳁ', texthl = '@exception', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapBreakpointRejected',
      { text = '', texthl = '@exception', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapLogPoint',
      { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
    )
    vim.fn.sign_define(
      'DapStopped',
      { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' }
    )
    keymaps.add({
      { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: toggle breakpoint' },
      { '<leader>dc', dap.continue, desc = 'Debug: continue' },
      { '<leader>dq', dap.disconnect, desc = 'Debug: disconnect' },
      { '<leader>ds', dap.step_over, desc = 'Debug: step over' },
      { '<leader>di', dap.step_into, desc = 'Debug: step into' },
      { '<leader>do', dap.step_out, desc = 'Debug: step out' },
      { '<leader>dr', dap.repl.toggle, desc = 'Debug: repl toggle' },
      { '<leader>dl', dap.run_last, desc = 'Debug: run last' },
      { '<leader>du', dapui.toggle, desc = 'Debug: ui toggle' },
      { '<leader>dt', dapui.toggle, desc = 'Debug: ui toggle' },
      { '<leader>dT', dap.terminate, desc = 'Debug: terminate (use disconnect)' },
      {
        '<leader>dS',
        function()
          dapui.float_element('stacks')
        end,
        desc = 'Debug: show stack',
      },
    })

    require('dap-vscode-js').setup({
      debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
      -- all options:
      -- adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      adapters = { 'pwa-node', 'node-terminal' },
    })
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.75 },
            { id = 'breakpoints', size = 0.25 },
            -- { id = 'scopes', size = 0.5 },
            -- { id = 'breakpoints', size = 0.25 },
            -- { id = 'watches', size = 0.25 },
          },
          position = 'left',
          size = 60,
        },
        {
          elements = {
            { id = 'console', size = 1.0 },
            -- { id = 'repl', size = 0.25 },
          },
          position = 'right',
          size = 100,
        },
      },
    })

    for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact' }) do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'npx',
          runtimeArgs = {
            'jest',
            '--runInBand',
            '--test-timeout=999999',
            '${file}',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest Tests (local to file - fix setup-jest.ts)',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'npx',
          runtimeArgs = {
            'jest',
            '--runInBand',
            '--test-timeout=999999',
            '${file}',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${fileDirname}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
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
        {
          type = 'pwa-node',
          -- attach to an already running node process with --inspect flag
          -- default port: 9222
          request = 'attach',
          -- allows us to pick the process using a picker
          processId = require('dap.utils').pick_process,
          -- name of the debug action
          name = 'Attach debugger to existing `node --inspect` process',
          -- for compiled languages like TypeScript or Svelte.js
          sourceMaps = true,
          -- resolve source maps in nested locations while ignoring node_modules
          resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
          -- path to src
          cwd = '${workspaceFolder}/src',
          -- is there any need for this? We don't care about performance when debugging, and
          -- intuitively, it would do nothing unless we set breakpoints. Keeping here for reference.
          -- skipFiles = { '**/node_modules/**/*.js' },
        },
      }
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end
  end,
}
