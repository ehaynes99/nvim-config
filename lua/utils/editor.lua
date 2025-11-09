local M = {}

-- telescope live grep within folder selected in nvim-tree
M.search_tree_dir = function()
  local api = require('nvim-tree.api')
  local utils = require('nvim-tree.utils')

  if utils.is_nvim_tree_buf(0) then
    local node = api.tree.get_node_under_cursor()
    if node then
      local path = node.absolute_path
      if vim.fn.isdirectory(path) == 1 then
        local telescope = require('telescope.builtin')
        telescope.live_grep({ cwd = path })
      end
    end
  end
end

M.is_file = function(bufnr)
  return vim.bo[bufnr].buflisted and vim.api.nvim_buf_get_name(bufnr) ~= ''
end

M.all_buffers = function()
  -- Collect all buffer information
  local lines = {}
  local highlights = {} -- Store line numbers where buffer names appear

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_info = M.buf_get_options(buf)

    -- Add buffer name (will be highlighted)
    local buf_name = buf_info.name ~= '' and buf_info.name or '[No Name]'
    table.insert(lines, buf_name)
    table.insert(highlights, #lines) -- Track this line for highlighting

    -- Define property order (excluding 'name' which is displayed as header)
    local property_order = {
      'id',
      'buftype',
      'buflisted',
      'bufhidden',
      'filetype',
      'modified',
      'modifiable',
      'readonly',
      'swapfile',
      'undofile',
    }

    -- Format and add properties in order
    for _, key in ipairs(property_order) do
      local value = buf_info[key]
      if value ~= nil then
        local formatted_value
        if type(value) == 'string' then
          formatted_value = "'" .. value .. "'"
        else
          formatted_value = tostring(value)
        end
        table.insert(lines, '  ' .. key .. ': ' .. formatted_value)
      end
    end

    -- Add blank line separator
    table.insert(lines, '')
  end

  -- Create scratch buffer
  local scratch_buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer name for identification
  vim.api.nvim_buf_set_name(scratch_buf, '[Buffer List]')

  -- Set buffer options before adding content
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = scratch_buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = scratch_buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = scratch_buf })

  vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, lines)

  -- Add highlighting for buffer names (make them bold)
  for _, line_num in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(scratch_buf, -1, 'Bold', line_num - 1, 0, -1)
  end

  -- Make buffer read-only after setting content
  vim.api.nvim_set_option_value('modifiable', false, { buf = scratch_buf })

  -- Open in a split
  vim.cmd('split')
  vim.api.nvim_win_set_buf(0, scratch_buf)

  -- Add autocommand to ensure buffer is wiped when window closes
  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = scratch_buf,
    once = true,
    callback = function()
      if vim.api.nvim_buf_is_valid(scratch_buf) then
        vim.api.nvim_buf_delete(scratch_buf, { force = true })
      end
    end,
  })

  -- Add keymap to close with 'q'
  vim.keymap.set('n', 'q', ':close<CR>', { buffer = scratch_buf, noremap = true, silent = true })
end

M.file_buffers = function()
  local all_buffers = vim.api.nvim_list_bufs()
  return vim.tbl_filter(M.is_file, all_buffers)
end

M.buffers_in_directory = function(path)
  return vim.tbl_filter(function(buf)
    local buf_path = vim.api.nvim_buf_get_name(buf)
    return buf_path:sub(1, #path) == path
  end, M.file_buffers())
end

M.buffers_not_in_directory = function(path)
  return vim.tbl_filter(function(buf)
    local buf_path = vim.api.nvim_buf_get_name(buf)
    return buf_path:sub(1, #path) ~= path
  end, M.file_buffers())
end

M.toggle_diff = function()
  if vim.wo.diff then
    vim.cmd('windo diffoff!')
  else
    vim.cmd('windo diffthis')
  end
end

-- see `:h options` section '3. Options summary'
M.buf_get_options = function(bufnr, option_names)
  local all_buffer_opts = {
    'bufhidden',
    'buflisted',
    'buftype',
    'filetype',
    'modifiable',
    'modified',
    'readonly',
    'swapfile',
    'undofile',
  }

  option_names = option_names or all_buffer_opts
  local result = {
    id = bufnr,
    name = vim.api.nvim_buf_get_name(bufnr),
  }
  for _, option in ipairs(option_names) do
    result[option] = vim.api.nvim_get_option_value(option, { buf = bufnr })
  end
  return result
end

M.close_hidden_buffers = function()
  local close_buffers = require('close_buffers')
  close_buffers.delete({ type = 'hidden', force = true })
  vim.cmd('redraw!')
end

M.close_all_buffers = function()
  local close_buffers = require('close_buffers')
  close_buffers.delete({ type = 'all', force = true })
  vim.cmd('redraw!')
end

M.close_buffers_not_in_project = function()
  local project = require('utils.project')
  local close_buffers = require('close_buffers')

  local project_root = project.project_root()
  local buffers_to_close = M.buffers_not_in_directory(project_root)
  for _, buf in ipairs(buffers_to_close) do
    close_buffers.delete({ type = buf, force = true })
  end
end

return M
