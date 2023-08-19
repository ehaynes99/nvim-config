return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup()

    vim.api.nvim_create_augroup('IndentBlankLineFix', {})
    vim.api.nvim_create_autocmd('WinScrolled', {
      group = 'IndentBlankLineFix',
      callback = function()
        if vim.v.event.all.leftcol ~= 0 then
          vim.cmd('silent! IndentBlanklineRefresh')
        end
      end,
    })
  end,
}
