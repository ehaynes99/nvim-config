local M = {}

M.close_if_successful = function(term, _, exit_code)
  if exit_code == 0 then
    term:close()
    if vim.api.nvim_buf_is_loaded(term.bufnr) then
      vim.api.nvim_buf_delete(term.bufnr, { force = true })
    end
  end
end

return M