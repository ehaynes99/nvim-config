local keymaps = require('keymaps')
local lspconfig = require('lspconfig')
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
        local supports_formatting = client.supports_method('textDocument/formatting')
        if has_null_ls then
          return client.name == 'null-ls'
        else
          return supports_formatting
        end
      end,
    })
  end
end

M.default_capabilities = function()
  local capabilities = cmp_nvim_lsp.default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

M.configure_server = function(server_name)
  if server_name == 'ts_ls' or server_name == 'eslint' then
    -- configured by `typescript-tools` or `nvim-eslint`, respectively
    return
  end
  local has_config, config = pcall(require, 'language_servers.' .. server_name)

  if not has_config then
    config = {}
  end

  if type(config) == 'function' then
    config()
  else
    local default_config = {
      on_attach = function(_, bufnr)
        keymaps.lsp_keymaps(bufnr, M.create_formatter(bufnr))
      end,
      capabilities = M.default_capabilities(),
    }
    lspconfig[server_name].setup(vim.tbl_extend('force', default_config, config))
  end
end

return M
