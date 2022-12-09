local M = {}

M.curry = function(fn)
  return function(...)
    local args = { ... }
    return function()
      ---@diagnostic disable-next-line: deprecated
      fn(unpack(args))
    end
  end
end

M.table_to_string = function(tbl)
  local result = '{'
  for k, v in pairs(tbl) do
    -- Check the key type (ignore any numerical keys - assume its an array)
    if type(k) == 'string' then
      result = result .. '["' .. k .. '"]' .. '='
    end

    -- Check the value type
    if type(v) == 'table' then
      result = result .. M.table_to_string(v)
    elseif type(v) == 'boolean' then
      result = result .. tostring(v)
    elseif type(v) == 'function' then
      result = result .. 'function() end'
    else
      result = result .. '"' .. v .. '"'
    end
    result = result .. ','
  end
  -- Remove leading commas from the result
  if result ~= '' then
    result = result:sub(1, result:len() - 1)
  end
  return result .. '}'
end

return M
