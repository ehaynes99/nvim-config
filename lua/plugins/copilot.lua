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
      dependencies = {
        { 'zbirenbaum/copilot.lua' },
        { 'nvim-lua/plenary.nvim' },
      },
      keys = {
        {
          '<leader>C',
          '<cmd>:CopilotChatToggle<CR>',
          desc = 'CopilotChat - Toggle',
        },
        {
          '<leader>cq',
          mode = { 'n', 'v' },
          function()
            print('Quick Chat')
            local input = vim.fn.input('Quick Chat: ')
            if input ~= '' then
              require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
            end
          end,
          desc = 'CopilotChat - Quick chat',
        },
      },
      build = 'make tiktoken',
      opts = {
        model = 'claude-3.5-sonnet',
        system_prompt = 'For any code in nodejs or TypeScript, use TypeScript in strict mode, ESM imports, no semicolons, and always prefer arrow functions. Add return type annotations to functions.',
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
