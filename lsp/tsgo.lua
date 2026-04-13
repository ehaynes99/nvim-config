local filtered_codes = {
  [6192] = true, -- unused imports (eslint handles)
  [80001] = true, -- convert to ES module
  [80005] = true, -- 'require' call may be converted to an import
  [80006] = true, -- may be converted to async function (auto-fix breaks code)
  [80007] = true, -- unnecessary await (eslint handles)
}

return {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    vim.keymap.set('n', '<leader>li', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { 'source.addMissingImports.ts' }, diagnostics = {} },
      })
    end, { desc = 'LSP: Add missing imports', buffer = bufnr })
  end,
  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
      if result and result.diagnostics then
        result.diagnostics = vim.tbl_filter(function(d)
          return not filtered_codes[d.code]
        end, result.diagnostics)
      end
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
    end,
  },
}
