local can_save = function(bufnr)
  local buf = vim.bo[bufnr]
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local has_filename = not (filename == nil or filename == '')
  local is_blank_type = buf.buftype == ''

  return buf.modified and has_filename and is_blank_type
end

local save_buffer

save_buffer = function(opts)
  local bufnr = opts.buf

  if can_save(bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd([[ write ]])
    end)
  end
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'BufLeave', 'BufWinLeave' }, {
  callback = save_buffer,
})