-- Bridge: promise-async (nvim-ufo: async(fn)) and lewis6991/async.nvim (refactoring.nvim: async.wrap/run)
-- Both use require("async") but need incompatible APIs. Resolve each lazily so timing doesn't matter.
package.loaded["async"] = true

local config_dir = vim.fn.stdpath("config")
local promise_mod, lewis_mod
local tried = {}

local function find_mods()
  if promise_mod and lewis_mod then return end
  for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/async.lua", true)) do
    if not vim.startswith(path, config_dir) and not tried[path] then
      tried[path] = true
      local ok, m = pcall(dofile, path)
      if ok and type(m) == "table" then
        if not promise_mod and type(rawget(m, "_id")) == "table" then
          promise_mod = m
        elseif not lewis_mod and type(m.wrap) == "function" then
          lewis_mod = m
        end
      end
    end
  end
end

local M = setmetatable({}, {
  __index = function(t, k)
    find_mods()
    local v = (lewis_mod and lewis_mod[k]) or (promise_mod and promise_mod[k])
    if v ~= nil then rawset(t, k, v) end
    return v
  end,
  __call = function(_, ...)
    find_mods()
    local mt = promise_mod and getmetatable(promise_mod)
    if mt and mt.__call then return mt.__call(promise_mod, ...) end
  end,
})

return M
