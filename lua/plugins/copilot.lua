return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      local keymaps = require('keymaps')
      require('copilot').setup({
        filetypes = {
          ['*'] = false,
          typescript = true,
          javascript = true,
          typescriptreact = true,
          javascriptreact = true,
          rust = true,
          lua = true,
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = 'kj',
            next = '<C-i>',
            prev = '<C-u>',
            dismiss = 'kk',
            accept_word = '<Nop>',
          },
        },
      })
      keymaps.add({
        {
          '<leader>KK',
          ':Copilot toggle<CR>',
          desc = 'Copilot: toggle',
        },
      })
      vim.keymap.set(
        'n',
        '<leader>wk',
        require('copilot.suggestion').toggle_auto_trigger,
        { desc = 'Copilot: toggle auto trigger' }
      )
    end,
  },
  {
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      branch = 'canary',
      dependencies = {
        { 'zbirenbaum/copilot.lua' },
        { 'nvim-lua/plenary.nvim' },
      },
      build = 'make tiktoken',
      opts = {
        -- debug = true, -- Enable debugging
        mappings = {
          reset = {
            normal = '<C-x>',
            insert = '<C-x>',
          },
        },
      },

      -- See Commands section for default commands if you want to lazy load on them
    },
  },
}
