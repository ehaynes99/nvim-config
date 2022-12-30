local auto_save = require('auto-save')

auto_save.setup({
  trigger_events = { 'InsertLeave', 'TextChanged', 'BufLeave' },
})
