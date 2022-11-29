local auto_save = require('auto-save')

auto_save.setup({
  trigger_events = { 'BufLeave', 'BufWinLeave', 'CmdlineEnter' },
})
