local native_lsp_config = function()
  -- vim.lsp.set_log_level('debug')
  local cmp_nvim_lsp = require('cmp_nvim_lsp')
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

  local default_capabilities = function()
    local capabilities = cmp_nvim_lsp.default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    return capabilities
  end

  local configure_server = function(server_name)
    if server_name == 'ts_ls' or server_name == 'eslint' then
      -- configured by `typescript-tools` or `nvim-eslint`, respectively
      return
    end

    local has_config, config = pcall(require, 'language_servers.' .. server_name)
    if not has_config then
      config = {}
    end

    local default_config = {
      capabilities = default_capabilities(),
    }

    local merged_config = vim.tbl_extend('force', default_config, config)

    vim.lsp.config(server_name, merged_config)
    vim.lsp.enable(server_name)
  end

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
    -- new format in nvim 0.10.x
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.HINT] = '',
        [vim.diagnostic.severity.INFO] = '',
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      -- source = 'always',
      source = true,
      header = '',
      prefix = '',
    },
  })

  require('lspconfig.ui.windows').default_options.border = 'rounded'

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })

  -- Configure servers manually
  for _, server_name in ipairs({
    'bashls',
    'cssls',
    'gopls',
    'graphql',
    'html',
    'jsonls',
    'lua_ls',
    'pyright',
    'sqlls',
  }) do
    configure_server(server_name)
  end
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
