local M = {}

M.setup_language = function()

  require('crates').setup()
end

M.on_attach = function(_, bufnr)
  
end
--
-- local rust_commands = {
--   ':RustCodeAction',
--   ':RustDebuggables',
--   ':RustDisableInlayHints',
--   ':RustEnableInlayHints',
--   ':RustExpandMacro',
--   ':RustHoverActions',
--   ':RustHoverRange',
--   ':RustJoinLines',
--   ':RustMoveItemDown',
--   ':RustMoveItemUp',
--   ':RustOpenCargo',
--   ':RustOpenExternalDocs',
--   ':RustParentModule',
--   ':RustPlay',
--   ':RustReloadWorkspace',
--   ':RustRunnables',
--   ':RustSSR',
--   ':RustSetInlayHints',
--   ':RustStartStandaloneServerForBuffer',
--   ':RustUnsetInlayHints',
--   ':RustViewCrateGraph',
-- }
--
-- local crates = require('crates')
-- local commands = {
--   ['Crates: Toggle'] = crates.toggle,
--   ['Crates: Reload'] = crates.reload,
--
--   ['Crates: Show versions'] = crates.show_versions_popup,
--   ['Crates: Show features'] = crates.show_features_popup,
--   ['Crates: Show dependencies'] = crates.show_dependencies_popup,
--
--   ['Crates: Update'] = crates.update_crate,
--   ['Crates: Update (visual)'] = crates.update_crates,
--   ['Crates: Update all'] = crates.update_all_crates,
--   ['Crates: Upgrade'] = crates.upgrade_crate,
--   ['Crates: Upgrade (visual)'] = crates.upgrade_crates,
--   ['Crates: Upgrade all'] = crates.upgrade_all_crates,
--
--   ['Crates: Open homepage'] = crates.open_homepage,
--   ['Crates: Open repository'] = crates.open_repository,
--   ['Crates: Open documentation'] = crates.open_documentation,
--   ['Crates: Open crates.io'] = crates.open_crates_io,
-- }
-- M.create_crate_commands = function(bufnr)
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesToggle', crates.toggle,
--     { desc = 'Enable or disable UI elements (virtual text and diagnostics)' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesReload', crates.reload,
--     { desc = 'Reload data (clears cache)' }
--     )
--
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesShowVersions', crates.show_versions_popup,
--     { desc = 'Show versions in popup' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesShowFeatures', crates.show_features_popup,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesShowDependencies', crates.show_dependencies_popup,
--     { desc = '' }
--     )
--
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesUpdateCrate', crates.update_crate,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesUpdateCrates', crates.update_crates,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesUpdateAll', crates.update_all_crates,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesUpgradeCrate', crates.upgrade_crate,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesUpgradeCrates', crates.upgrade_crates,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesUpgradAll', crates.upgrade_all_crates,
--     { desc = '' }
--     )
--
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesOpenHomepage', crates.open_homepage,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesOpenRepository', crates.open_repository,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesOpenDocumentation', crates.open_documentation,
--     { desc = '' }
--     )
--   vim.api.nvim_buf_create_user_command(bufnr, 'CratesOpenCratesIO', crates.open_crates_io,
--     { desc = '' }
--     )
-- end

return M