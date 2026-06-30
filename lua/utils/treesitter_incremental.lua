-- Self-contained treesitter incremental selection.
--
-- nvim-treesitter's `main` branch dropped the module system, including the
-- `incremental_selection` module. This re-implements the same behaviour using
-- only the native `vim.treesitter` API so the familiar keymaps keep working:
--   * init_selection   -> select the node under the cursor
--   * node_incremental -> grow the selection to the parent node
--   * node_decremental -> shrink back to the previous node
--   * scope_incremental-> grow to the enclosing scope (falls back to parent)

local api = vim.api

local M = {}

---@type table<integer, TSNode[]>
local selections = {}

-- Visually select a node's range (charwise).
---@param node TSNode
local function update_selection(node)
  -- Always start from normal mode so the `v` below reliably *enters* visual
  -- mode instead of toggling it off when called from an existing selection.
  if api.nvim_get_mode().mode:match('[vV\22]') then
    local esc = api.nvim_replace_termcodes('<Esc>', true, false, true)
    api.nvim_feedkeys(esc, 'nx', false)
  end

  local srow, scol, erow, ecol = node:range() -- 0-indexed, end-exclusive

  -- Convert the exclusive end to the last included (row, col).
  if ecol == 0 then
    erow = erow - 1
    local line = api.nvim_buf_get_lines(0, erow, erow + 1, true)[1]
    ecol = math.max(#line - 1, 0)
  else
    ecol = ecol - 1
  end

  api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd('normal! v')
  api.nvim_win_set_cursor(0, { erow + 1, ecol })
end

---@param a TSNode
---@param b TSNode
local function same_range(a, b)
  local a1, a2, a3, a4 = a:range()
  local b1, b2, b3, b4 = b:range()
  return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

function M.init_selection()
  local buf = api.nvim_get_current_buf()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  selections[buf] = { node }
  update_selection(node)
end

-- Grow the selection. `get_parent` lets callers pick the growth strategy.
---@param get_parent fun(node: TSNode): TSNode|nil
local function grow(get_parent)
  return function()
    local buf = api.nvim_get_current_buf()
    local stack = selections[buf]
    if not stack or #stack == 0 then
      return M.init_selection()
    end

    local node = stack[#stack]
    local parent = get_parent(node)
    -- Skip ancestors that cover the exact same range so the selection always
    -- visibly changes.
    while parent and same_range(parent, node) do
      parent = parent:parent()
    end
    if parent then
      table.insert(stack, parent)
      update_selection(parent)
    end
  end
end

M.node_incremental = grow(function(node)
  return node:parent()
end)

-- Without a portable `locals` query helper on `main`, "scope" growth degrades
-- to ordinary parent growth, which is a reasonable approximation.
M.scope_incremental = M.node_incremental

function M.node_decremental()
  local buf = api.nvim_get_current_buf()
  local stack = selections[buf]
  if not stack or #stack < 2 then
    return
  end
  table.remove(stack)
  update_selection(stack[#stack])
end

---@param buf integer
function M.attach(buf)
  local opts = { buffer = buf, silent = true }
  vim.keymap.set('n', '<C-space>', M.init_selection,
    vim.tbl_extend('force', opts, { desc = 'TS: init selection' }))
  vim.keymap.set('x', '<TAB>', M.node_incremental,
    vim.tbl_extend('force', opts, { desc = 'TS: grow node' }))
  vim.keymap.set('x', '<S-TAB>', M.node_decremental,
    vim.tbl_extend('force', opts, { desc = 'TS: shrink node' }))
  vim.keymap.set('x', '<C-space>', M.scope_incremental,
    vim.tbl_extend('force', opts, { desc = 'TS: grow scope' }))
end

return M
