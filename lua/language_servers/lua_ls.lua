local get_workspace = function()
  local create_workspace = function(paths)
    local result = {
      library = {},
      checkThirdParty = false,
    }
    for _, path in ipairs(paths) do
      result.library[path] = true
    end
    return result
  end

  local cwd = vim.fn.getcwd()

  local home_dir = vim.fn.expand('$HOME')
  if cwd == home_dir .. '/.config/awesome' then
    return create_workspace({
      '/usr/share/awesome/lib',
    })
  end
end

return {
  before_init = require('neodev.lsp').before_init,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.inspect(vim.api.nvim_list_runtime_paths()),
      },
      diagnostics = {
        globals = { 'vim', 'awesome', 'client', 'screen', 'root' },
      },
      workspace = get_workspace(),
      completion = {
        showWord = 'Disable',
      },
    },
  },
}
