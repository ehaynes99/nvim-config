return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
          },
        },
        on_attach = function(client, bufnr)
          local set = vim.keymap.set

          -- Commented out: uncomment and rebind any you use frequently
          -- set('n', '<key>', function() vim.cmd.RustLsp('codeAction') end,
          --   { desc = 'Rust: Code action (grouped)', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end,
          --   { desc = 'Rust: Hover actions', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('explainError') end,
          --   { desc = 'Rust: Explain error', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('renderDiagnostic') end,
          --   { desc = 'Rust: Render diagnostic', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('expandMacro') end,
          --   { desc = 'Rust: Expand macro', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('runnables') end,
          --   { desc = 'Rust: Runnables', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('testables') end,
          --   { desc = 'Rust: Testables', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('debuggables') end,
          --   { desc = 'Rust: Debuggables', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('parentModule') end,
          --   { desc = 'Rust: Parent module', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('openDocs') end,
          --   { desc = 'Rust: Open docs.rs', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('openCargo') end,
          --   { desc = 'Rust: Open Cargo.toml', buffer = bufnr })
          -- set('n', '<key>', function() vim.cmd.RustLsp('joinLines') end,
          --   { desc = 'Rust: Join lines', buffer = bufnr })

          local rust_commands = {
            { label = 'Code Action (grouped)', cmd = 'codeAction' },
            { label = 'Hover Actions', cmd = { 'hover', 'actions' } },
            { label = 'Explain Error', cmd = 'explainError' },
            { label = 'Render Diagnostic', cmd = 'renderDiagnostic' },
            { label = 'Expand Macro', cmd = 'expandMacro' },
            { label = 'Runnables', cmd = 'runnables' },
            { label = 'Testables', cmd = 'testables' },
            { label = 'Debuggables', cmd = 'debuggables' },
            { label = 'Parent Module', cmd = 'parentModule' },
            { label = 'Open docs.rs', cmd = 'openDocs' },
            { label = 'Open Cargo.toml', cmd = 'openCargo' },
            { label = 'Join Lines', cmd = 'joinLines' },
            { label = 'Related Tests', cmd = 'relatedTests' },
            { label = 'Syntax Tree', cmd = 'syntaxTree' },
            { label = 'Fly Check', cmd = 'flyCheck' },
          }

          set('n', '<leader>lA', function()
            vim.ui.select(rust_commands, {
              prompt = 'RustLsp',
              format_item = function(item) return item.label end,
            }, function(choice)
              if choice then
                vim.cmd.RustLsp(choice.cmd)
              end
            end)
          end, { desc = 'Rust: Command picker', buffer = bufnr })
        end,
      },
    }
  end,
}
