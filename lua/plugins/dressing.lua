return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {
      override = function(conf)
        -- display under cursor, not on top of it
        conf.anchor = "NW"
        conf.row = 1
      end,
    },
  },
}
