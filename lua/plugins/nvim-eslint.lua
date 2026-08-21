return {
  -- 'esmuellert/nvim-eslint',
  'ehaynes99/nvim-eslint',
  branch = 'node-args',
  -- dir = '/home/erich/workspace/ehaynes99/nvim-eslint',
  config = function()
    local toolchain = require('utils.js_toolchain')
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

    -- When a project has an oxlint or biome config, that tool owns JS/TS/MJS
    -- linting. Eslint still attaches for filetypes it doesn't cover (md/json/yaml).
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= 'eslint' then return end
        if not toolchain.JS_LIKE[vim.bo[args.buf].filetype] then return end
        if toolchain.has_oxlint_config(args.buf) or toolchain.has_biome_config(args.buf) then
          vim.lsp.buf_detach_client(args.buf, args.data.client_id)
        end
      end,
    })
  end,
}
