local project_utils = require('utils.project')
local terminal_utils = require('plugins.toggleterm.terminals.terminal_utils')

local M = {}

local filter_flag = function(pm, name)
  if not name then return '' end
  if pm == 'pnpm' then
    return ' --filter=' .. name
  elseif pm == 'npm' then
    return ' --workspace=' .. name
  elseif pm == 'yarn' then
    return ' --workspace ' .. name
  end
  return ''
end

M.detect_type = function(file)
  local dir = vim.fs.dirname(file)
  local function has_file(marker)
    return vim.fs.find(marker, { upward = true, path = dir })[1] ~= nil
  end
  local function has_dir(marker)
    return vim.fs.find(marker, { upward = true, path = dir, type = 'directory' })[1] ~= nil
  end
  if has_file('package.json') then return 'node' end
  if has_file('Cargo.toml') then return 'rust' end
  if has_file('go.mod') then return 'golang' end
  if has_dir('lua') then return 'lua' end
  return nil
end

M.node = function(Terminal)
  local term = Terminal:new({
    direction = 'vertical',
    -- close_on_exit = false,
    hidden = true,
    on_exit = terminal_utils.close_if_successful,
  })

  local run = function()
    local test_file = vim.api.nvim_buf_get_name(0)

    local pkg_file = project_utils.package_json_path(test_file)
    if not pkg_file then
      vim.notify('could not find package.json: ' .. test_file, vim.log.levels.ERROR)
      return
    end

    local pkg_dir = vim.fs.dirname(pkg_file)
    local pkg = vim.fn.json_decode(vim.fn.readfile(pkg_file))

    local ok, pm = pcall(project_utils.package_manager, test_file)
    if not ok then
      vim.notify('could not detect package manager: ' .. test_file, vim.log.levels.ERROR)
      return
    end

    local mono_root = project_utils.monorepo_root(test_file)
    local cwd = mono_root or pkg_dir

    local filter = mono_root and filter_flag(pm, pkg.name) or ''

    local test_script = (pkg.scripts or {}).test or ''
    print('test_script: ' .. test_script)
    local is_vitest = test_script:find('vitest') ~= nil or test_script:find('quo%-p') ~= nil
    print('is_vitest: ' .. vim.inspect(is_vitest))

    local relative_path = test_file:sub(#pkg_dir + 2)

    local vitest_flags = is_vitest and '--watch --disableConsoleIntercept ' or ''
    local cmd = pm .. filter .. ' test ' .. vitest_flags .. relative_path
    print('cmd: ' .. cmd)

    if term:is_open() then
      term:change_dir(cwd)
    else
      term.dir = cwd
    end
    term.cmd = cmd
    term:toggle()
  end

  return { run = run }
end

M.rust = function(_Terminal)
  return {
    run = function()
      vim.notify('Test script is not configured for rust', vim.log.levels.WARN)
    end,
  }
end

M.golang = function(_Terminal)
  return {
    run = function()
      vim.notify('Test script is not configured for golang', vim.log.levels.WARN)
    end,
  }
end

M.lua = function(_Terminal)
  return {
    run = function()
      vim.notify('Test script is not configured for lua', vim.log.levels.WARN)
    end,
  }
end

return function(Terminal)
  local handlers = {}

  local get_handler = function(lang)
    if not handlers[lang] then
      handlers[lang] = M[lang](Terminal)
    end
    return handlers[lang]
  end

  local run = function()
    local test_file = vim.api.nvim_buf_get_name(0)
    local lang = M.detect_type(test_file)
    if not lang then
      vim.notify('Could not detect project type for: ' .. test_file, vim.log.levels.WARN)
      return
    end
    get_handler(lang).run()
  end

  return { run = run }
end
