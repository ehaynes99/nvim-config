local keymaps = require('keymaps')

return {
  'jackMort/ChatGPT.nvim',
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
