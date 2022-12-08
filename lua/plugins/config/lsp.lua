local illuminate = require('illuminate')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local null_ls = require('null-ls')
local null_ls_sources = require('null-ls.sources')
local fidget = require('fidget')
local legendary = require('legendary')
local legendary_toolbox = require('legendary.toolbox')

local lazy = legendary_toolbox.lazy
local servers = {
  'cssls',
  'html',
  'tsserver',
  'pyright',
  'bashls',
  'jsonls',
  'yamlls',
  'sumneko_lua',
}

local server_options = {
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
          },
        },
        telemetry = {
          enable = false,
        },
        completion = {
          showWord = 'Disable',
        },
      },
    },
  },
  tsserver = {
    settings = {
      diagnostics = {
        ignoredCodes = {
          -- some typescript diagnostics are invalid and/or are better
          -- handled by eslint. All message codes:
          -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
          6133, -- unused variable - eslint will handle
          6138, -- unused property - eslint will handle
          80001, -- convert to ES module suggestion
        },
      },
    },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local lsp_keymaps = function(buf)
  local keymaps = {
    { 'gD', vim.lsp.buf.declaration, description = 'LSP: Goto declaration' },
    { 'gd', vim.lsp.buf.definition, description = 'LSP: Goto definition' },
    { 'gt', vim.lsp.buf.type_definition, description = 'LSP: Goto type definition' },
    { 'gI', vim.lsp.buf.implementation, description = 'LSP: Goto implementation' },
    { 'gr', vim.lsp.buf.references, description = 'LSP: Find references' },
    { '<leader>ld', vim.diagnostic.open_float, description = 'LSP: Open diagnostics' },
    { '<leader>lf', lazy(vim.lsp.buf.format, { async = true }), description = 'LSP: Format document' },
    { '<leader>lh', vim.lsp.buf.hover, description = 'LSP: Hover tooltip' },
    { '<leader>lx', vim.lsp.buf.code_action, description = 'LSP: Code actions native' },
    -- provided by 'weilbith/nvim-code-action-menu' plugin
    { '<leader>la', ':CodeActionMenu<CR>', description = 'LSP: Code actions menu' },
    { '<leader>lj', lazy(vim.diagnostic.goto_next, { buffer = 0 }), description = 'LSP: Next diagnostic' },
    { '<leader>lk', lazy(vim.diagnostic.goto_prev, { buffer = 0 }), description = 'LSP: Previous diagnostic' },
    { '<leader>lr', vim.lsp.buf.rename, description = 'LSP: Rename' },
    { '<leader>ls', vim.lsp.buf.signature_help, description = 'LSP: Signature help' },
    { '<leader>lq', vim.diagnostic.setloclist, description = 'LSP: Set loclist' },
  }
  local opts = { buffer = buf }
  for _, mapping in ipairs(keymaps) do
    mapping.opts = opts
  end
  legendary.keymaps(keymaps)
end

local lsp_formatter = function(bufnr)
  local filetype = vim.bo.filetype

  local method = null_ls.methods.FORMATTING
  local has_null_ls = #null_ls_sources.get_available(filetype, method) > 0

  vim.lsp.buf.format({
    filter = function(client)
      if has_null_ls then
        return client.name == 'null-ls'
      elseif client.supports_method('textDocument/formatting') then
        return true
      else
        return false
      end
    end,
    bufnr = bufnr,
  })
end

local mason_setup = function()
  mason.setup()

  mason_lsp.setup({
    ensure_installed = servers,
    automatic_installation = true,
  })
end

local null_ls_setup = function()
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup({
    debug = false,
    sources = {
      formatting.prettier,
      formatting.black.with({ extra_args = { '--fast' } }),
      formatting.stylua,
      -- formatting.google_java_format,
      diagnostics.flake8,
      diagnostics.eslint,
    },
  })
end

local lsp_setup = function()
  for _, server in pairs(servers) do
    local opts = {
      on_attach = function(client, bufnr)
        lsp_keymaps(bufnr)
        lsp_formatter(bufnr)
        illuminate.on_attach(client)
      end,
      capabilities = capabilities,
    }

    if server_options[server] then
      opts = vim.tbl_deep_extend('force', server_options[server], opts)
    end

    lspconfig[server].setup(opts)
  end
  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  local config = {
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })
end

mason_setup()
lsp_setup()
null_ls_setup()
-- progress reporter
fidget.setup({})
