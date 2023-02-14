local M = {}

M.setup = function()
  local dap = require('dap')
  local dapui = require('dapui')

  dapui.setup({
    floating = {
      max_height = 0.9,
      max_width = 0.5,
      border = 'rounded',
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
  })

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open({})
  end

  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close({})
  end

  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close({})
  end
end

return M
