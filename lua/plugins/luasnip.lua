local luasnip = require('luasnip')
local snipmate = require('luasnip.loaders.from_snipmate')

luasnip.setup({
  history = false,
})

snipmate.lazy_load()
