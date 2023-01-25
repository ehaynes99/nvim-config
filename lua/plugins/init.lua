return {
  --utilities
  { 'nvim-lua/plenary.nvim', priority = 999 },
  { 'nvim-tree/nvim-web-devicons', priority = 999 },
  { 'rcarriga/nvim-notify', opts = {
    top_down = false,
  } },

  -- misc editor improvements
  { 'numToStr/Comment.nvim', config = true, event = 'VeryLazy' },
  -- { 'petertriho/nvim-scrollbar', config = true },
  { 'mrjones2014/legendary.nvim', config = true, event = 'VeryLazy' },
  { 'chentoast/marks.nvim', config = true, event = 'VeryLazy' },
  { 'kosayoda/nvim-lightbulb', opts = {
    autocmd = { enabled = true },
  }, event = 'VeryLazy' },
  { 'kazhala/close-buffers.nvim' },
  { 'lukas-reineke/indent-blankline.nvim' },
  { 'nvim-pack/nvim-spectre', config = true },
  {
    'APZelos/blamer.nvim',
    config = function()
      vim.g.blamer_date_format = '%m/%d/%y'
    end,
  },
  { 'Almo7aya/openingh.nvim' },
  { 'kevinhwang91/nvim-bqf' },
  { 'smjonas/live-command.nvim', opts = {
    commands = {
      Norm = { cmd = 'norm' },
    },
  } },

  { 'sindrets/diffview.nvim' },
  { 'rmagatti/session-lens', config = true },
  { 'rafcamlet/nvim-luapad' },

  { 'windwp/nvim-ts-autotag' },
  { 'windwp/nvim-autopairs', opts = {
    check_ts = true,
    enable_check_bracket_line = false,
  } },
  { 'kylechui/nvim-surround', config = true },
}
