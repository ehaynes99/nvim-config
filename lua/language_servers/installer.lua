local keymaps = require('keymaps')
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local null_ls = require('null-ls')
local null_ls_sources = require('null-ls.sources')

local M = {}

-- not sure where to put this. The plugin doesn't have its own config
vim.g.code_action_menu_window_border = 'rounded'

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

M.default_server_config = {
  on_attach = function(_, bufnr)
    keymaps.lsp_keymaps(bufnr, M.create_formatter(bufnr))
  end,
  capabilities = M.default_capabilities,
}

M.configure_server = function(server_name)
  local default_config = {
    on_attach = function(_, bufnr)
      keymaps.lsp_keymaps(bufnr, M.create_formatter(bufnr))
    end,
    capabilities = M.default_capabilities,
  }
  local has_config, config = pcall(require, 'language_servers.' .. server_name)

  if not has_config then
    config = {}
  end

  if type(config) == 'function' then
    config()
  else
    lspconfig[server_name].setup(vim.tbl_extend('force', default_config, config))
  end
end

return M
