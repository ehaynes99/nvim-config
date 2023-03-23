return {
  'iamcco/markdown-preview.nvim',
  config = function()
    vim.g.mkdp_markdown_css = vim.fn.stdpath('config') .. '/lua/plugins/markdown-preview/github-markdown.css'
    vim.fn['mkdp#util#install']()
  end,
}
