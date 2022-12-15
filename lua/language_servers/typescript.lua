local keymaps = require('keymaps')
local lsp_utils = require('plugins.config.lsp.lsp_utils')

local organize_imports = function(buf)
  vim.lsp.buf.execute_command({
    command = '_typescript.organizeImports',
    arguments = { buf, skipDestructiveCodeActions = true },
  })
end

return {
  on_attach = function(_, bufnr)
    keymaps.lsp_keymaps(bufnr, lsp_utils.create_formatter(bufnr))
  end,
  capabilities = lsp_utils.default_capabilities,
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
  commands = {
    OrganizeImports = {
      organize_imports,
      description = 'LSP: Organize imports',
    },
  },
}
