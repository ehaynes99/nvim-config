local get_library_paths = function()
  local paths = {
    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
  }

  local cwd = vim.fn.getcwd()

  -- get completion for installed plugins if opened in vim config dir
  if cwd == vim.fn.stdpath('config') then
    paths[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
    paths[vim.fn.stdpath('config') .. '/lua'] = true
    local pack_dir = vim.fn.stdpath('data') .. '/site/pack'

    local add_glob = function(glob)
      for _, dir in ipairs(vim.split(vim.fn.glob(glob), '\n')) do
        if dir ~= '' then
          paths[dir] = true
        end
      end
    end
    add_glob(pack_dir .. '/*/start/*/lua')
    add_glob(pack_dir .. '/*/opt/*/lua')
  elseif cwd == '/home/erich/.config/awesome' then
    print('adding awesome!')
    paths['/usr/share/awesome/lib'] = true
  end

  return paths
end

return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.inspect(vim.api.nvim_list_runtime_paths()),
      },

      diagnostics = {
        globals = { 'vim', 'awesome', 'client', 'screen', 'root' },
      },
      workspace = {
        library = get_library_paths(),
        checkThirdParty = false,
      },
      completion = {
        showWord = 'Disable',
      },
    },
  },
}
