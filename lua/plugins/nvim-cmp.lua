local cmp_mapping = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  return cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- Prevent autocomplete unless explicitly tabbing into the list
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
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
    'Saecki/crates.nvim',
  },
  config = function()
    local cmp = require('cmp')

    local context = require('cmp.config.context')

    cmp.setup({
      enabled = function()
        -- Disable completion in comments
        if vim.api.nvim_get_mode().mode == 'c' then
          return true -- Keep enabled in command mode
        end
        return not context.in_treesitter_capture('comment')
          and not context.in_syntax_group('Comment')
      end,
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
        { name = 'buffer', keyword_length = 3 },
        { name = 'luasnip' },
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
