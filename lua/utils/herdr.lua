-- Build '@path#Lstart-end' references and type them into the Claude Code
-- session running in the neighboring herdr pane. Text is sent without a
-- newline, so it lands in the prompt rather than submitting on its own.

local M = {}

---Whether this Neovim is running inside a herdr-managed pane. Gates the whole
---integration, including whether claudecode.nvim loads.
---@return boolean
function M.is_active()
  return vim.env.HERDR_ENV == '1'
end

local function bin()
  local herdr = vim.env.HERDR_BIN_PATH
  if herdr == nil or herdr == '' then
    return 'herdr'
  end
  return herdr
end

local function run(args)
  local result = vim.system(vim.list_extend({ bin() }, args), { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  -- Mutating commands like send-text exit 0 with no output, so an undecodable
  -- body means success rather than failure.
  local ok, decoded = pcall(vim.json.decode, result.stdout)
  if not ok then
    return true
  end
  return decoded
end

---Focus a pane by id. The CLI only focuses directionally, so this goes
---straight to the socket API's pane.focus.
---@param pane_id string
local function focus(pane_id)
  local path = vim.env.HERDR_SOCKET_PATH
  if path == nil or path == '' then
    return
  end
  local pipe = vim.uv.new_pipe(false)
  if not pipe then
    return
  end
  pipe:connect(path, function()
    local payload = vim.json.encode({
      id = 'nvim-herdr-focus',
      method = 'pane.focus',
      params = { pane_id = pane_id },
    })
    pipe:write(payload .. '\n', function()
      pipe:close()
    end)
  end)
end

local directions = { h = 'left', j = 'down', k = 'up', l = 'right' }

---Targets our own pane rather than --current: the server's focused pane isn't
---necessarily the one we are running in.
---@param key 'h'|'j'|'k'|'l'
function M.focus_neighbor(key)
  local pane = vim.env.HERDR_PANE_ID
  if pane == nil or pane == '' then
    return
  end
  vim.system({ bin(), 'pane', 'focus', '--direction', directions[key], '--pane', pane })
end

---Find the agent pane sharing this pane's tab. Herdr reports a real
---agent_status only for panes it recognizes as a coding agent; shells and
---editors report 'unknown'.
---@return string|nil pane_id
---@return string|nil error
function M.agent_pane()
  local self_pane = vim.env.HERDR_PANE_ID
  local workspace = vim.env.HERDR_WORKSPACE_ID
  if self_pane == nil or self_pane == '' or workspace == nil or workspace == '' then
    return nil, 'not running inside a herdr pane'
  end

  local response = run({ 'pane', 'list', '--workspace', workspace })
  local panes = type(response) == 'table' and response.result and response.result.panes
  if not panes then
    return nil, 'could not list herdr panes'
  end

  local tab
  for _, pane in ipairs(panes) do
    if pane.pane_id == self_pane then
      tab = pane.tab_id
      break
    end
  end
  if not tab then
    return nil, 'could not locate this pane (' .. self_pane .. ')'
  end

  for _, pane in ipairs(panes) do
    if pane.tab_id == tab and pane.pane_id ~= self_pane and pane.agent_status ~= 'unknown' then
      return pane.pane_id
    end
  end

  return nil, 'no agent pane in this tab'
end

---@param text string
---@param opts table|nil { focus = boolean }
function M.send(text, opts)
  opts = opts or {}

  local pane, err = M.agent_pane()
  if not pane then
    vim.notify('herdr: ' .. err, vim.log.levels.WARN)
    return false
  end

  if run({ 'pane', 'send-text', pane, text }) == nil then
    vim.notify('herdr: failed to send to ' .. pane, vim.log.levels.ERROR)
    return false
  end

  if opts.focus ~= false then
    focus(pane)
  end

  vim.notify('Sent ' .. vim.trim(text), vim.log.levels.INFO)
  return true
end

local function relative_path()
  return vim.fn.expand('%:.')
end

---@return string
function M.buffer_ref()
  return '@' .. relative_path()
end

---@return string
function M.line_ref()
  return string.format('@%s#L%d', relative_path(), vim.fn.line('.'))
end

---Reference for the visual selection. Leaves visual mode.
---@return string
function M.selection_ref()
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  vim.cmd('normal! \27')

  if start_line == end_line then
    return string.format('@%s#L%d', relative_path(), start_line)
  end
  return string.format('@%s#L%d-%d', relative_path(), start_line, end_line)
end

---@return string|nil
function M.tree_node_ref()
  local node = require('nvim-tree.api').tree.get_node_under_cursor()
  if not node then
    return nil
  end
  return '@' .. vim.fn.fnamemodify(node.absolute_path, ':.')
end

---Buffer ref, or the tree node ref when the cursor is in a file tree.
---@return string|nil
function M.context_ref()
  if vim.bo.filetype == 'NvimTree' then
    return M.tree_node_ref()
  end
  return M.buffer_ref()
end

---@param builder fun(): string|nil
local function with_ref(builder, action)
  return function()
    local ref = builder()
    if ref then
      action(ref)
    end
  end
end

local function copy(ref)
  vim.fn.setreg('"', ref)
  vim.fn.setreg('+', ref)
  vim.notify('Copied ' .. ref, vim.log.levels.INFO)
end

local function send(ref)
  -- Trailing space keeps the prompt ready for whatever you type next.
  M.send(ref .. ' ')
end

M.send_buffer_ref = with_ref(M.buffer_ref, send)
M.send_line_ref = with_ref(M.line_ref, send)
M.send_selection_ref = with_ref(M.selection_ref, send)
M.send_tree_node_ref = with_ref(M.tree_node_ref, send)
M.send_context_ref = with_ref(M.context_ref, send)

M.copy_buffer_ref = with_ref(M.buffer_ref, copy)
M.copy_line_ref = with_ref(M.line_ref, copy)
M.copy_selection_ref = with_ref(M.selection_ref, copy)
M.copy_tree_node_ref = with_ref(M.tree_node_ref, copy)
M.copy_context_ref = with_ref(M.context_ref, copy)

function M.attach_keymaps()
  if not M.is_active() then
    return
  end

  local set = vim.keymap.set

  set('n', '<leader>as', M.send_line_ref, { desc = 'Claude: send line ref' })
  set('x', '<leader>as', M.send_selection_ref, { desc = 'Claude: send selection ref' })
  set('n', '<leader>ab', M.send_context_ref, { desc = 'Claude: send buffer/tree ref' })

  set('n', '<leader>aS', M.copy_line_ref, { desc = 'Claude: copy line ref' })
  set('x', '<leader>aS', M.copy_selection_ref, { desc = 'Claude: copy selection ref' })
  set('n', '<leader>aB', M.copy_context_ref, { desc = 'Claude: copy buffer/tree ref' })
end

return M
