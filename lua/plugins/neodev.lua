return {
  'folke/neodev.nvim',
  config = function()
    require('neodev').setup({
      setup_jsonls = false,
      lspconfig = false,
      library = {
        plugins = { 'nvim-dap-ui' },
        types = true,
      },
    })
  end,
}
