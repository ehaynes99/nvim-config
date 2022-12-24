local M = {}

-- retain reference to directory when opened
M.INITIAL_DIR = vim.fn.getcwd()

return M
