return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup({
      filetypes = {
        ['*'] = false,
        typescript = true,
        rust = true,
        lua = true,
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = 'kj',
          next = '<A-j>',
          prev = '<A-k>',
          dismiss = 'kk',
          accept_word = '<Nop>',
        },
      },
    })
  end,
}
