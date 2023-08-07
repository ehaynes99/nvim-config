return {
  'akinsho/bufferline.nvim',
  -- enabled = false,
  config = function()
    -- vim.cmd([[highlight CwdHeader guifg=#C34043]])
    require('bufferline').setup({
      options = {
        offsets = {
          {
            filetype = 'NvimTree',
            text = function()
              return (vim.fn.getcwd():gsub(vim.fn.expand('$HOME'), '~'):gsub('workspace/openphone/projects', 'W/O/P'))
            end,
            -- highlight = 'Directory',
            -- highlight = '@exception',
            highlight = 'NvimTreeRootFolder',

            separator = true,
            text_align = 'left',
          },
        },
      },
    })
  end,
}
