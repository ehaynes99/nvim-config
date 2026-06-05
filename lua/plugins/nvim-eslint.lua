local OXLINT_CONFIGS = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts' }
local JS_LIKE = {
  javascript = true,
  javascriptreact = true,
  ['javascript.jsx'] = true,
  typescript = true,
  typescriptreact = true,
  ['typescript.tsx'] = true,
}

local function has_oxlint_config(bufnr)
  return vim.fs.find(OXLINT_CONFIGS, {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = 'file',
    stop = vim.fn.expand('$HOME'),
    limit = 1,
  })[1] ~= nil
end

return {
  -- 'esmuellert/nvim-eslint',
  'ehaynes99/nvim-eslint',
  branch = 'node-args',
  -- dir = '/home/erich/workspace/ehaynes99/nvim-eslint',
  config = function()
    local nvim = require('nvim-eslint')
    nvim.setup({
      filetypes = { 'yaml' },
      settings = {
        format = true,
        useFlatConfig = true,
        codeActionOnSave = {
          enable = false,
          mode = 'all',
        },
        onIgnoredFiles = 'off',
        -- Pin the server's cwd to the directory of the nearest eslint config.
        -- In a pnpm monorepo (e.g. web2/web), the client's root_dir is the git
        -- root, and the server's default `location` mode falls back to that root
        -- when it can't infer the flat-config dir -- so eslint runs from the git
        -- root and can't resolve plugins (`Cannot find module ...`). Forcing
        -- `directory` makes the server chdir into the package, matching the CLI.
        workingDirectory = function(bufnr)
          local dir = require('nvim-eslint').resolve_eslint_config_dir(bufnr)
          if dir then
            return { directory = dir }
          end
          return { mode = 'location' }
        end,
      },
    })

    -- When a project has an oxlint config, oxlint owns JS/TS/MJS linting.
    -- Eslint still attaches for filetypes oxlint doesn't cover (md/json/yaml).
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= 'eslint' then return end
        if not JS_LIKE[vim.bo[args.buf].filetype] then return end
        if has_oxlint_config(args.buf) then
          vim.lsp.buf_detach_client(args.buf, args.data.client_id)
        end
      end,
    })
  end,
}
