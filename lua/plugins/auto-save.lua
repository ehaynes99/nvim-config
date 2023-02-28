return {
  'Pocco81/auto-save.nvim',
  enabled = false,
  opts = {
    trigger_events = { 'InsertLeave', 'TextChanged', 'BufLeave' },
    execution_message = {
      message = function()
        return ''
      end,
    },
  },
}
