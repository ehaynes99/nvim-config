return {
  'Pocco81/auto-save.nvim',
  opts = {
    trigger_events = { 'InsertLeave', 'TextChanged' },
    execution_message = {
      message = function()
        return ''
      end,
    },
  },
}
