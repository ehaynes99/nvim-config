return {
  {
    'zbirenbaum/copilot.lua',
    enabled = true,
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        filetypes = {
          ['*'] = false,
          typescript = true,
          javascript = true,
          typescriptreact = true,
          javascriptreact = true,
          rust = true,
          lua = true,
          graphql = true,
          go = true,
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = 'kj',
            next = '<C-]>',
            prev = '<C-u>',
            dismiss = 'kk',
            accept_word = '<Nop>',
          },
        },
      })
      vim.keymap.set('n', '<leader>KK', ':Copilot toggle<CR>', { desc = 'Copilot: toggle' })
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
      enabled = true,
      dependencies = {
        { 'zbirenbaum/copilot.lua' },
        { 'nvim-lua/plenary.nvim' },
      },
      keys = {
        {
          '<leader>C',
          '<cmd>:CopilotChatToggle<CR>',
          desc = 'CopilotChat - Toggle',
          mode = { 'n', 'x' },
        },
        {
          '<leader>cq',
          mode = { 'n', 'v' },
          function()
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
        model = 'claude-3.7-sonnet',
        system_prompt = 'Be brief unless asked for details. Code-only unless I ask otherwise. If asked about a specific part of some code, only display changes for that part unless asked to expand. Do not address existing errors in code unless I ask you to; that usually means I have something close to what I want, but I want you to solve something else. For any code in nodejs or TypeScript, use TypeScript in strict mode, ESM imports, no semicolons, and always prefer arrow functions. Add return type annotations to functions.',
        -- debug = true, -- Enable debugging
        mappings = {
          reset = {
            normal = '<C-x>',
            insert = '<C-x>',
          },
          stop = {
            normal = '<C-c>',
            callback = function()
              local copilot = require('CopilotChat')
              copilot.stop()
            end,
          },
        },
      },

      -- See Commands section for default commands if you want to lazy load on them
    },
  },
}
