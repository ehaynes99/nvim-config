-- Only keys lspconfig's bundled tsc.lua doesn't define: rtp lsp/*.lua are
-- deep-merged and the plugin's copy wins, so cmd/root_dir/settings stay there.

local filtered_codes = {
  [6192] = true, -- unused imports (eslint handles)
  [80001] = true, -- convert to ES module
  [80005] = true, -- 'require' call may be converted to an import
  [80006] = true, -- may be converted to async function (auto-fix breaks code)
  [80007] = true, -- unnecessary await (eslint handles)
}

local ms = vim.lsp.protocol.Methods

local function filter_diagnostics(diagnostics)
  return vim.tbl_filter(function(d)
    return not filtered_codes[d.code]
  end, diagnostics or {})
end

-- tsc currently doesn't call refresh on in-editor file changes (only on file-watcher events).
local function refresh_all_buffers(client_id)
  for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(client_id)) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      vim.lsp.diagnostic._refresh(bufnr, client_id)
    end
  end
end

-- Per-client debounce timer for cross-buffer refreshes.
local refresh_timers = {}
local function schedule_cross_buffer_refresh(client_id)
  local t = refresh_timers[client_id]
  if t then
    t:stop()
    t:close()
  end
  t = vim.uv.new_timer()
  refresh_timers[client_id] = t
  t:start(
    750,
    0,
    vim.schedule_wrap(function()
      if refresh_timers[client_id] == t then
        t:stop()
        t:close()
        refresh_timers[client_id] = nil
      end
      refresh_all_buffers(client_id)
    end)
  )
end

return {
  -- Without this tsc skips sending the refresh signal entirely.
  capabilities = {
    workspace = {
      diagnostics = {
        refreshSupport = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    vim.keymap.set('n', '<leader>li', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { 'source.fixAll' }, diagnostics = {} },
        filter = function(action)
          return action.title == 'Fix All'
        end,
      })
    end, { desc = 'LSP: Add missing imports', buffer = bufnr })

    -- tsc only refreshes off workspace/didChangeWatchedFiles, so an in-editor
    -- edit never invalidates diagnostics in dependent open buffers.
    vim.api.nvim_create_autocmd('LspNotify', {
      buffer = bufnr,
      callback = function(args)
        if
          args.data.client_id == client.id
          and (
            args.data.method == ms.textDocument_didChange
            or args.data.method == ms.textDocument_didOpen
          )
        then
          schedule_cross_buffer_refresh(client.id)
        end
      end,
    })
  end,
  handlers = {
    -- Pull-model: filter codes on the diagnostic response.
    [ms.textDocument_diagnostic] = function(err, result, ctx)
      if result and result.items then
        result.items = filter_diagnostics(result.items)
      end
      return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
    end,
    -- If tsc ever does send a refresh request, honor it.
    ['workspace/diagnostic/refresh'] = function(_, _, ctx)
      refresh_all_buffers(ctx.client_id)
      return vim.NIL
    end,
  },
}
