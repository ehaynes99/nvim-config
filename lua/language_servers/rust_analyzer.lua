require('crates').setup()

return function()
  require('rust-tools').setup({
    server = {
      ---@diagnostic disable-next-line: unused-local
      on_attach = function(_, bufnr)
        -- local filetype = vim.bo[bufnr].filetype
        -- print('filetype: ' .. filetype)
      end,
    },
  })
end
