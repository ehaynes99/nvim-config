-- nvim-treesitter `main` branch.
--
-- The legacy `master` branch (with its `require('nvim-treesitter.configs').setup`
-- module system) is frozen. `main` is a full, incompatible rewrite: it only
-- installs parsers/queries and exposes a few helpers, while the actual features
-- (highlight, folds, indentation, injections) are driven by Neovim's built-in
-- treesitter support. We wire those up ourselves in a FileType autocmd below.
--
-- Migrated away from the old modules:
--   highlight            -> vim.treesitter.start()
--   indent               -> indentexpr = nvim-treesitter.indentexpr()
--   incremental_selection-> utils.treesitter_incremental (native re-impl)
--   textobjects          -> nvim-treesitter-textobjects `main` select API
--   autotag              -> nvim-ts-autotag standalone setup (see plugins/init.lua)
--   endwise              -> nvim-treesitter-endwise `init()` (module-free path)
--   playground           -> built-in :InspectTree / :EditQuery (plugin dropped)

local ensure_installed = {
  'bash',
  'go',
  'html',
  'javascript',
  'kotlin',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'rust',
  'sql',
  'swift',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  -- `main` does not support lazy-loading.
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    'RRethy/nvim-treesitter-endwise',
  },
  config = function()
    require('nvim-treesitter').setup()

    -- Install any missing parsers (async; a no-op when already present).
    require('nvim-treesitter').install(ensure_installed)

    -- endwise has a module-free path on Neovim 0.9+ that attaches via its own
    -- FileType autocmd; this just turns it on.
    require('nvim-treesitter-endwise').init()

    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
      },
    })

    local nvim_treesitter = require('nvim-treesitter')
    local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
    local incremental = require('utils.treesitter_incremental')

    local textobjects = {
      ['aa'] = '@parameter.outer',
      ['ia'] = '@parameter.inner',
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    }

    -- Turn on treesitter features for a buffer whose parser is installed.
    local function activate(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      if not pcall(vim.treesitter.start, buf, lang) then
        return
      end

      -- Indentation (experimental on `main`).
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

      -- Text object select mappings.
      for lhs, query in pairs(textobjects) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select_textobject(query, 'textobjects')
        end, { buffer = buf, silent = true, desc = 'TS select ' .. query })
      end

      -- Incremental selection mappings.
      incremental.attach(buf)
    end

    -- Per-buffer activation, with auto-install of missing parsers to mirror the
    -- old `auto_install = true`.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_activate', { clear = true }),
      callback = function(args)
        local buf = args.buf

        -- Respect snacks.nvim bigfile handling (replaces the old
        -- `highlight.disable` callback that skipped large buffers).
        if vim.b[buf].snacks_bigfile then
          return
        end

        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end

        if vim.list_contains(nvim_treesitter.get_installed('parsers'), lang) then
          activate(buf, lang)
        elseif vim.list_contains(nvim_treesitter.get_available(), lang) then
          nvim_treesitter.install({ lang }):await(function()
            vim.schedule(function()
              activate(buf, lang)
            end)
          end)
        end
      end,
    })
  end,
}
