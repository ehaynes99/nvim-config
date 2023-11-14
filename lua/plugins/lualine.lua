return {
  'nvim-lualine/lualine.nvim',
  opts = {
    sections = {
      -- lualine_a = { 'mode' },
      lualine_a = {},
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { 'filename', newfile_status = true, path = 1 } },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = {
        function()
          local line_count = vim.api.nvim_buf_line_count(0)
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          local padded = string.rep(' ', #tostring(line_count) - #tostring(row)) .. row
          return ('line# %s/%d'):format(padded, line_count)
        end,
      },
      lualine_z = { 'location' },
    },
  },
}
