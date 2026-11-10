return {
  'iamcco/markdown-preview.nvim',
  config = function()
    vim.g.mkdp_markdown_css = vim.fn.stdpath('config') .. '/lua/plugins/markdown-preview/github-markdown.css'
    vim.fn['mkdp#util#install']()

    vim.g.mkdp_auto_close = 0
    vim.api.nvim_create_autocmd('BufDelete', {
      callback = function(args)
        if vim.fn.exists('#MKDP_REFRESH_INIT' .. args.buf) == 1 then
          -- preview_close targets bufnr('%'), which may not be the deleted buffer
          vim.api.nvim_buf_call(args.buf, function() vim.fn['mkdp#rpc#preview_close']() end)
        end
      end,
    })
  end,
}
