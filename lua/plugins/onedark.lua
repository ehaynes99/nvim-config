return {
  'navarasu/onedark.nvim',
  commit = 'df090f9d72d43aa51dec5760c44da288b58a79b6',
  config = function()
    local onedark = require('onedark')
    onedark.setup({
      style = 'warm',
    })

    onedark.load()
  end,
}
