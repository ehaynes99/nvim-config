local native_lsp_config = function()
  -- vim.lsp.set_log_level('debug')
  local keymaps = require('keymaps')

  local create_formatter = function(bufnr)
    return function()
      local filetype = vim.bo.filetype
      local null_ls = require('null-ls')
      local null_ls_sources = require('null-ls.sources')
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

  -- Set default capabilities for all LSP servers
  local function make_capabilities()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    return capabilities
  end

  vim.lsp.config('*', {
    capabilities = make_capabilities(),
  })

  -- Set up LspAttach autocommand for keymaps
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      keymaps.lsp_keymaps(bufnr, create_formatter(bufnr))
    end,
  })

  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = true,
      header = '',
      prefix = '',
    },
  })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'towolf/vim-helm',
    'saadparwaiz1/cmp_luasnip',
    'b0o/schemastore.nvim',
  },
  config = function()
    vim.lsp.handlers['workspace/diagnostic/refresh'] = function(_, _, ctx)
      local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
      pcall(vim.diagnostic.reset, ns)
      return true
    end
    native_lsp_config()
  end,
}
