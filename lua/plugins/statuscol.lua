return {
  'luukvbaal/statuscol.nvim',
  -- enabled = false,
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({
      -- configuration goes here, for example:
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        { text = { '%s' }, click = 'v:lua.ScSa' },
        {
          sign = { name = { 'Diagnostic' }, maxwidth = 1, auto = false },
        },
        -- { text = { builtin.lnumfunc } },
        {
          text = { builtin.lnumfunc},
          condition = { true, builtin.not_empty },
          click = 'v:lua.ScLa',
        },
        -- {
        --   sign = { name = { '.*' }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        --   click = 'v:lua.ScSa',
        -- },
        -- { text = { ' ' } },
      },
    })
  end,
}
