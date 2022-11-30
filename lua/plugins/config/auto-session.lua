local autosession = require('auto-session')

autosession.setup({
  log_level = 'error',
  auto_session_suppress_dirs = {
    '~/',
    '~/tmp',
    '~/workspace',
    '~/all-workspaces',
    '/',
  },
})
