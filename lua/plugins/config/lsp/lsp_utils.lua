local cmp_nvim_lsp = require('cmp_nvim_lsp')
local null_ls = require('null-ls')
local null_ls_sources = require('null-ls.sources')

local M = {}

M.create_formatter = function(bufnr)
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

M.default_capabilities = (function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
end)()

return M
