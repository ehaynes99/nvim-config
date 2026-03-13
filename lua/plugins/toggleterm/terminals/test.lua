local project_utils = require('utils.project')
local terminal_utils = require('plugins.toggleterm.terminals.terminal_utils')

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

return function(Terminal)
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
