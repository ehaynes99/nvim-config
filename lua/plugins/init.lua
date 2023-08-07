return {
  --utilities
  { 'nvim-lua/plenary.nvim', priority = 999 },
  { 'nvim-tree/nvim-web-devicons', priority = 999 },

  -- misc editor improvements
  { 'numToStr/Comment.nvim', config = true, event = 'VeryLazy' },
  { 'mrjones2014/legendary.nvim', config = true, event = 'VeryLazy' },
  { 'chentoast/marks.nvim', config = true, event = 'VeryLazy' },
  { 'kazhala/close-buffers.nvim' },
  { 'lukas-reineke/indent-blankline.nvim', enabled = true },
  { 'nvim-pack/nvim-spectre', config = true },
  { 'Almo7aya/openingh.nvim' },
  { 'kevinhwang91/nvim-bqf' },
  { 'mbbill/undotree' },
  { 'sindrets/diffview.nvim' },
  { 'rafcamlet/nvim-luapad' },

  { 'windwp/nvim-ts-autotag' },
  { 'windwp/nvim-autopairs', opts = {
    check_ts = true,
    enable_check_bracket_line = false,
  } },
  { 'kylechui/nvim-surround', config = true },
}
