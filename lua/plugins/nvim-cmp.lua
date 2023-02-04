local cmp_mapping = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  -- from the wiki, but I can't tell what this does...
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  return cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ---@diagnostic disable-next-line: missing-parameter
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- Prevent autocomplete unless explicitly tabbing into the list
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  })
end

local cmp_snippet = function()
  local luasnip = require('luasnip')
  local snipmate = require('luasnip.loaders.from_snipmate')

  luasnip.setup({
    history = false,
  })

  snipmate.lazy_load()

  return {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  }
end

return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp_mapping(),
      snippet = cmp_snippet(),
      preselect = cmp.PreselectMode.None,
      formatting = {
        fields = { 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.menu = ({
            luasnip = '[Snippet]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[Nvim lua]',
            buffer = '[Buffer]',
            path = '[Path]',
            emoji = '[Emoji]',
            crates = '[Cargo]',
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'buffer', keyword_length = 3 },
        { name = 'path' },
        { name = 'crates' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
    })
  end,
}
