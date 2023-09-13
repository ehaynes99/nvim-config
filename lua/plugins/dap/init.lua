return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      build = 'git reset --hard && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
    },
  },
  config = function()
    require('plugins.dap.dap-ui').setup()
    require('plugins.dap.dap-vscode-js').setup()
  end,
}
