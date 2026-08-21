local M = {}

M.JS_LIKE = {
  javascript = true,
  javascriptreact = true,
  ['javascript.jsx'] = true,
  typescript = true,
  typescriptreact = true,
  ['typescript.tsx'] = true,
}

local function find_upward(bufnr, filenames)
  return vim.fs.find(filenames, {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1] ~= nil
end

M.has_oxlint_config = function(bufnr)
  return find_upward(bufnr, { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' })
end

M.has_biome_config = function(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  -- Same detection nvim-lspconfig's own lsp/biome.lua uses for its root_dir.
  local configs =
    require('lspconfig.util').insert_package_json({ 'biome.json', 'biome.jsonc' }, 'biomejs', filename)
  return find_upward(bufnr, configs)
end

return M
