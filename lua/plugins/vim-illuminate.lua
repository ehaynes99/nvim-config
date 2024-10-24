return {
  'RRethy/vim-illuminate',
  config = function()
    local illuminate = require('illuminate')
    -- kanagawa "winterRed"
    vim.cmd('hi IlluminatedWordRead guibg=#43242B')

    require('keymaps').add({
      { '<leader>;', illuminate.goto_next_reference, desc = 'LSP: Go to next reference' },
      { ';', illuminate.goto_next_reference, desc = 'LSP: Go to next reference' },
      { '<leader>:', illuminate.goto_prev_reference, desc = 'LSP: Go to previous reference' },
    })
  end,
}
