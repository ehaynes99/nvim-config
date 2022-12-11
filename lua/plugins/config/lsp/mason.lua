local cmp_nvim_lsp = require('cmp_nvim_lsp')
local keymaps = require('keymaps.mappings')
local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local null_ls = require('null-ls')
local null_ls_sources = require('null-ls.sources')
local server_settings = require('plugins.config.lsp.server_settings')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local function lsp_formatter(bufnr)
  return function()
    local filetype = vim.bo.filetype

    local has_null_ls = #null_ls_sources.get_available(filetype, null_ls.methods.FORMATTING) > 0

    vim.lsp.buf.format({
      async = true,
      bufnr = bufnr,
      filter = function(client)
        if has_null_ls then
          return client.name == 'null-ls'
        else
          return client.supports_method('textDocument/formatting')
        end
      end,
    })
  end
end

mason.setup({
  ui = {
    border = 'rounded',
  },
})

mason_lsp.setup({
  ensure_installed = vim.tbl_keys(server_settings),
  automatic_installation = true,
})

mason_lsp.setup_handlers({
  function(server_name)
    local settings = server_settings[server_name]
    if type(settings) == 'function' then
      settings()
      return
    end

    local opts = {
      on_attach = function(_, bufnr)
        keymaps.lsp_keymaps(bufnr, lsp_formatter(bufnr))
      end,
      capabilities = capabilities,
    }
    if type(settings) == 'table' then
      opts = vim.tbl_extend('force', opts, settings)
    end
    lspconfig[server_name].setup(opts)
  end,
})
