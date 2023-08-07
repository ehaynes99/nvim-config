return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {
      override = function(conf)
        -- display under cursor, not on top of it
        if (conf.row == nil or conf.row == 0) then
          conf.row = 4
        end
        return conf
      end,
    },
  },
}
