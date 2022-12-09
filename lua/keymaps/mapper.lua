local legendary = require('legendary')

local M = {}

local add_to_legendary = function(mappings)
  local keymaps = {}

  for _, mapping in ipairs(mappings) do
    table.insert(keymaps, {
      mapping.key,
      mapping.cmd,
      description = mapping.desc,
      mode = mapping.mode,
      opts = mapping.opts,
    })
  end

  legendary.keymaps(keymaps)
end

-- convert a string to a table of modes
-- accepts single letters in the form of 'nivxt'
local parse_modes = function(modes)
  if modes == nil then
    return { 'n' }
  else
    local mode_list = {}
    for mode in string.gmatch(modes, '.') do
      table.insert(mode_list, mode)
    end
    return mode_list
  end
end

-- abstraction around defining keymaps so I can change my mind
-- about legendary or which-key or...
M.add = function(mappings_or_default_opts, mappings)
  local default_opts = mappings_or_default_opts
  if mappings == nil then
    default_opts = {}
    mappings = mappings_or_default_opts
  end
  default_opts.silent = true

  local normalized = {}
  for _, mapping in ipairs(mappings) do
    -- local opts = vim.tbl_extend(default_opts, mapping.opts or {})
    table.insert(normalized, {
      key = mapping[1],
      cmd = mapping.cmd or mapping[2],
      desc = mapping.desc,
      mode = parse_modes(mapping.mode),
      -- opts = opts,
      opts = default_opts,
    })
  end

  add_to_legendary(normalized)
end

return M
