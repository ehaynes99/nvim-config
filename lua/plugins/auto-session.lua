local autosession = require('auto-session')
local session_lens = require('session-lens')

autosession.setup({
  log_level = 'error',
  auto_session_suppress_dirs = {
    '~/',
    '~/tmp/*',
    '~/workspace',
    '~/all-workspaces',
    '/',
    '/tmp/*',
  },
})

session_lens.setup({})
