return {
  'RRethy/vim-illuminate',
  config = function()
    local illuminate = require('illuminate')
    -- kanagawa "winterRed"
    vim.cmd('hi IlluminatedWordRead guibg=#43242B')

    vim.keymap.set('n', '<leader>;', illuminate.goto_next_reference, { desc = 'LSP: Go to next reference' })
    vim.keymap.set('n', ';', illuminate.goto_next_reference, { desc = 'LSP: Go to next reference' })
    vim.keymap.set('n', '<leader>:', illuminate.goto_prev_reference, { desc = 'LSP: Go to previous reference' })
  end,
}
