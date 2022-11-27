local create_cmd = vim.api.nvim_create_autocmd

local compiled_packer_exists = function()
  local f = io.open(vim.g.COMPILED_PACKER_FILE, 'r')
  if f ~= nil then
    io.close(f)
    return true
  end
end

-- remove compiled plugins when any file in `lua/plugins` changes
create_cmd({ 'BufWrite' }, {
  pattern = vim.g.PLUGINS_DIR .. '**',
  callback = function(args)
    local dirty = vim.fn.getbufinfo(args.buf)[1].changed ~= 0
    if dirty and compiled_packer_exists() then
      local notify = require('notify')
      os.remove(vim.g.COMPILED_PACKER_FILE)
      notify('Removed compiled plugins')
    end
  end,
})

-- sync packer on start if compiled plugins not present
create_cmd({ 'VimEnter' }, {
  callback = function()
    if not compiled_packer_exists() then
      require('packer').sync()
    end
  end,
})
