local keymaps = require('keymaps')

return {
  'jackMort/ChatGPT.nvim',
  enabled = false,
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('chatgpt').setup({

    })

    keymaps.add({

    })
  end,
}
