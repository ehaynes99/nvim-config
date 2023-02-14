return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mxsdev/nvim-dap-vscode-js',
    {
      'microsoft/vscode-js-debug',
      build = {
        'npm install --legacy-peer-deps',
        'npm run compile',
      },
    },
  },
  config = function()
    require('plugins.dap.dap-ui').setup()
    require('plugins.dap.dap-vscode-js').setup()
  end,
}
