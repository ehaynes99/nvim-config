return {
  cssls = nil,
  html = nil,
  pyright = nil,
  bashls = nil,
  jsonls = nil,
  rust_analyzer = function()
    require('rust-tools').setup({})
  end,
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.inspect(vim.api.nvim_list_runtime_paths()),
        },

        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
          },
          checkThirdParty = false,
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
