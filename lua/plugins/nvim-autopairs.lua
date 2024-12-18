return {
  'windwp/nvim-autopairs',
  config = function()
    local Rule = require('nvim-autopairs.rule')
    local npairs = require('nvim-autopairs')
    npairs.setup({
      check_ts = true,
      enable_check_bracket_line = false,
    })
    npairs.add_rules({
      Rule('```', '```', { 'markdown', 'vimwiki', 'copilot-chat' }),
      Rule('```.*$', '```', { 'markdown', 'vimwiki', 'copilot-chat' }),

      -- Rule('```', '```\n\n```', { 'markdown', 'vimwiki', 'copilot-chat' }):set_end_pair_length(4), -- Counts the \n\n``` as 4 characters
      -- Rule('```.*$', '```\n\n```', { 'markdown', 'vimwiki', 'copilot-chat' }):set_end_pair_length(4),

      -- -- Basic triple backtick rule
      -- Rule('```$', '\n\n```', { 'markdown', 'vimwiki', 'copilot-chat' }):set_end_pair_length(4):use_regex(true),
      --
      -- -- Language-specific rule that triggers after typing the language name
      -- Rule('```%w+$', '\n\n```', { 'markdown', 'vimwiki', 'copilot-chat' }):set_end_pair_length(4):use_regex(true),
    })
  end,
}
