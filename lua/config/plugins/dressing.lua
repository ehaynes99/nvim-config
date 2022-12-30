local dressing = require('dressing')

dressing.setup({
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
  -- select = {
  --   get_config = function(opts)
  --     if opts.kind == 'legendary.nvim' then
  --       return {
  --         telescope = {
  --           sorter = require('telescope.sorters').fuzzy_with_index_bias({}),
  --         },
  --       }
  --     else
  --       return {}
  --     end
  --   end,
  -- },
})
