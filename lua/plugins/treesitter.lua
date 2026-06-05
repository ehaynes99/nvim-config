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

    -- nvim-treesitter master branch is archived and ships a broken
    -- `set-lang-from-info-string!` directive under Neovim 0.11+ where
    -- `match[id]` is now `TSNode[]` instead of `TSNode`. Re-register it
    -- with a list-aware implementation so markdown fenced-code injections
    -- (used by render-markdown.nvim, LSP hovers, etc.) stop crashing.
    local alias_to_lang = {
      ex = 'elixir',
      pl = 'perl',
      sh = 'bash',
      uxn = 'uxntal',
      ts = 'typescript',
    }
    vim.treesitter.query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
      local node = match[pred[2]]
      if type(node) == 'table' then
        node = node[#node]
      end
      if not node then
        return
      end
      local alias = vim.treesitter.get_node_text(node, bufnr):lower()
      metadata['injection.language'] = vim.filetype.match({ filename = 'a.' .. alias })
        or alias_to_lang[alias]
        or alias
    end, { force = true, all = false })
  end,
}
