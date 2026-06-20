return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
  },
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter.configs')

    treesitter.setup({
      ensure_installed = {
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
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          scope_incremental = '<C-space>',
          node_incremental = '<TAB>',
          node_decremental = '<S-TAB>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
      indent = {
        enable = true,
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, bufnr)
          return vim.b[bufnr].snacks_bigfile or false
        end,
      },

      -- from 'windwp/nvim-ts-autotag' plugin
      autotag = {
        enable = true,
      },

      -- from 'RRethy/nvim-treesitter-endwise' plugin
      endwise = {
        enable = true,
      },
      playground = {
        enable = true,
      },
    })

    -- nvim-treesitter's master branch is archived and its custom query
    -- predicates/directives are incompatible with Neovim 0.11+, where a
    -- match now maps each capture id to a `TSNode[]` list instead of a
    -- single `TSNode`. The unpatched handlers call node methods on the
    -- list table and throw. This breaks:
    --   * treesitter indentation -- `ecma/indents.scm` uses `#not-kind-eq?`,
    --     so every newline fell back to indent 0 (cursor jumps to column 0)
    --   * markdown fenced-code injections (render-markdown.nvim, LSP hovers)
    -- Re-register the affected handlers with list-aware implementations.
    local ts_query = vim.treesitter.query
    local reg_opts = { force = true, all = false }

    -- Resolve a match capture to a single node, tolerating the new
    -- list-valued match format from Neovim 0.11+.
    local function match_node(match, id)
      local node = match[id]
      if type(node) == 'table' then
        node = node[#node]
      end
      return node
    end

    ts_query.add_predicate('kind-eq?', function(match, _, _, pred)
      local node = match_node(match, pred[2])
      if not node then
        return true
      end
      return vim.list_contains({ unpack(pred, 3) }, node:type())
    end, reg_opts)

    ts_query.add_predicate('nth?', function(match, _, _, pred)
      local node = match_node(match, pred[2])
      local n = tonumber(pred[3])
      if node and node:parent() and node:parent():named_child_count() > n then
        return node:parent():named_child(n) == node
      end
      return false
    end, reg_opts)

    ts_query.add_predicate('is?', function(match, _, bufnr, pred)
      local locals = require('nvim-treesitter.locals')
      local node = match_node(match, pred[2])
      if not node then
        return true
      end
      local _, _, kind = locals.find_definition(node, bufnr)
      return vim.list_contains({ unpack(pred, 3) }, kind)
    end, reg_opts)

    local alias_to_lang = {
      ex = 'elixir',
      pl = 'perl',
      sh = 'bash',
      uxn = 'uxntal',
      ts = 'typescript',
    }
    ts_query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
      local node = match_node(match, pred[2])
      if not node then
        return
      end
      local alias = vim.treesitter.get_node_text(node, bufnr):lower()
      metadata['injection.language'] = vim.filetype.match({ filename = 'a.' .. alias })
        or alias_to_lang[alias]
        or alias
    end, reg_opts)

    ts_query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
      local id = pred[2]
      local node = match_node(match, id)
      if not node then
        return
      end
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
      if not metadata[id] then
        metadata[id] = {}
      end
      metadata[id].text = string.lower(text)
    end, reg_opts)
  end,
}
