return {
  'folke/neodev.nvim',
  config = function()
    require('neodev').setup({
      setup_jsonls = false,
      lspconfig = false,
    })
  end,
}
