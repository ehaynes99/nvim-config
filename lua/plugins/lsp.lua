local native_lsp_config = function()
  -- vim.lsp.set_log_level('debug')
  local keymaps = require('keymaps')

  local create_formatter = function(bufnr)
    -- Pick the right formatter: oxfmt > null-ls > any other LSP with formatting.
    local function run_format()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, c in ipairs(clients) do
        if c.name == 'oxfmt' then
          vim.notify('formatting with oxfmt', vim.log.levels.DEBUG)
          vim.lsp.buf.format({ async = true, bufnr = bufnr, name = 'oxfmt' })
          return
        end
      end

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

    return function()
      local oxlint = vim.lsp.get_clients({ bufnr = bufnr, name = 'oxlint' })[1]
      if not oxlint then
        run_format()
        return
      end

      vim.notify('oxlint fixAll', vim.log.levels.DEBUG)
      oxlint:exec_cmd({
        title = 'Apply Oxlint automatic fixes',
        command = 'oxc.fixAll',
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
      }, { bufnr = bufnr }, function()
        vim.schedule(run_format)
      end)
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
    -- Force every server onto utf-16. Neovim advertises {utf-8, utf-16, utf-32}
    -- by default, and tsgo grabs utf-8 while oxlint/oxfmt/eslint/copilot stay on
    -- utf-16. Mixed offset encodings on one buffer is unsupported and corrupts
    -- LSP change tracking (_changetracking.lua buf_state errors on every keystroke,
    -- then broken positions/highlighting). Offering only utf-16 keeps them aligned.
    capabilities.general = capabilities.general or {}
    capabilities.general.positionEncodings = { 'utf-16' }
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

  vim.o.winborder = 'rounded'
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

    -- Both servers ship with nvim-lspconfig; root_markers gate startup on config files.
    vim.lsp.enable('oxlint')
    vim.lsp.enable('oxfmt')
  end,
}
