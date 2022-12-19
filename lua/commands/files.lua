local editor_utils = require('utils.editor')

vim.api.nvim_create_user_command('SetFiletype', function()
  if not editor_utils.buf_is_file(0) then
    return
  end
  local on_choice = function(filetype)
    vim.api.nvim_buf_set_option(0, 'filetype', filetype)
  end
  local types = vim.fn.getcompletion('', 'filetype')
  vim.ui.select(types, { prompt = 'Select filetype:' }, on_choice)
end, { desc = 'Open filetype select menu' })
