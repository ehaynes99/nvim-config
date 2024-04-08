return {
  'luukvbaal/statuscol.nvim',
  config = function()
    local builtin = require('statuscol.builtin')
    require('statuscol').setup({
      relculright = true,
      segments = {
        { text = { builtin.foldfunc } },
        { sign = { name = { 'Diagnostic' }, maxwidth = 1, auto = false } },
        { sign = { name = { '.*' }, maxwidth = 1, auto = true, wrap = true } },
        { text = { builtin.lnumfunc } },
      },
    })
  end,
}
