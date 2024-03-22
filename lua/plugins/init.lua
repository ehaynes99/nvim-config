return {
  --utilities
  { 'nvim-lua/plenary.nvim', priority = 999 },
  { 'nvim-tree/nvim-web-devicons', priority = 999 },

  -- misc editor improvements
  { 'numToStr/Comment.nvim', config = true, event = 'VeryLazy' },
  { 'chentoast/marks.nvim', config = true, event = 'VeryLazy' },
  { 'kazhala/close-buffers.nvim' },
  { 'nvim-pack/nvim-spectre', config = true },
  { 'Almo7aya/openingh.nvim' },
  -- better quickfix
  { 'kevinhwang91/nvim-bqf' },
  { 'mbbill/undotree' },
  { 'sindrets/diffview.nvim' },
  { 'rafcamlet/nvim-luapad' },
  { 'nmac427/guess-indent.nvim', config = true },

  -- syntax
  { 'towolf/vim-helm' },
  { 'kyoh86/vim-jsonl' },
  { 'mustache/vim-mustache-handlebars' },
  { 'keith/swift.vim' },

  { 'windwp/nvim-ts-autotag' },
  { 'windwp/nvim-autopairs', opts = {
    check_ts = true,
    enable_check_bracket_line = false,
  } },
  { 'kylechui/nvim-surround', config = true },
}
