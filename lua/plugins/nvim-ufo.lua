local keymaps = require('keymaps')

return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
    'neovim/nvim-lspconfig',
  },
  config = function()
    local ufo = require('ufo')

    -- local tmp = '  ⬇  ↨ ↧ ⇓ ⇕ ⟱  ⇟ ⇊  🡙 🡣 🡫 🡳 🡻 🢃🠟🢃'
    ufo.setup({
      ---@diagnostic disable-next-line: assign-type-mismatch
      close_fold_kinds = { 'imports' },
      -- fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      --   -- local prefix = ('  %d '):format(endLnum - lnum)
      --   local prefix = ('🢃🢃🢃 %d '):format(endLnum - lnum)
      --   local newVirtText = { { prefix, '@keyword.return' } }
      --   local sufWidth = vim.fn.strdisplaywidth(prefix)
      --   local targetWidth = width - sufWidth
      --   local curWidth = 0
      --   for i, chunk in ipairs(virtText) do
      --     local chunkText = chunk[1]
      --     if i == 1 then
      --       for j, #prefix do
      --         if not vim.startswith(chunkText, ' ') then
      --           break
      --         end
      --         
      --         -- if 
      --         -- if chunkText[j] ~= prefix[j] then
      --         --   chunkText = chunkText:sub(j)
      --         --   break
      --         -- end
      --       end
      --     end
      --     
      --     local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      --     if targetWidth > curWidth + chunkWidth then
      --       table.insert(newVirtText, chunk)
      --     else
      --       chunkText = truncate(chunkText, targetWidth - curWidth)
      --       local hlGroup = chunk[2]
      --       table.insert(newVirtText, { chunkText, hlGroup })
      --       chunkWidth = vim.fn.strdisplaywidth(chunkText)
      --       -- str width returned from truncate() may less than 2nd argument, need padding
      --       if curWidth + chunkWidth < targetWidth then
      --         prefix = prefix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      --       end
      --       break
      --     end
      --     curWidth = curWidth + chunkWidth
      --   end
      --   -- table.insert(newVirtText, { prefix, 'MoreMsg' })
      --   return newVirtText
      -- end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        -- local prefix = ('  %d '):format(endLnum - lnum)
        local prefix = ('🢃🢃🢃 %d '):format(endLnum - lnum)
        local newVirtText = { { prefix, '@keyword.return' } }
        local sufWidth = vim.fn.strdisplaywidth(prefix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              prefix = prefix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        -- table.insert(newVirtText, { prefix, 'MoreMsg' })
        return newVirtText
      end,
    })

    keymaps.add({
      { 'zR', ufo.openAllFolds, desc = 'Open all folds' },
      { 'zM', ufo.closeAllFolds, desc = 'Close all folds' },
    })
  end,
}
