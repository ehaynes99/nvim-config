return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  opts = {
    input = {
      anchor = 'NW',
      override = function(conf)
        -- display under cursor, not on top of it
        if conf.anchor == 'NW' and (conf.row == nil or conf.row == 0) then
          conf.row = 1
        end
        return conf
      end,
    },
  },
}
