local lualine = require('lualine')

lualine.setup({
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      function()
        return (vim.fn.getcwd():gsub(vim.fn.expand('$HOME'), '~'))
      end,
      { 'filename', newfile_status = true, path = 1 },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})
