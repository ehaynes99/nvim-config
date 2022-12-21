local M = {}

M.rust_commands = {
  ':RustCodeAction',
  ':RustDebuggables',
  ':RustDisableInlayHints',
  ':RustEnableInlayHints',
  ':RustExpandMacro',
  ':RustHoverActions',
  ':RustHoverRange',
  ':RustJoinLines',
  ':RustMoveItemDown',
  ':RustMoveItemUp',
  ':RustOpenCargo',
  ':RustOpenExternalDocs',
  ':RustParentModule',
  ':RustPlay',
  ':RustReloadWorkspace',
  ':RustRunnables',
  ':RustSSR',
  ':RustSetInlayHints',
  ':RustStartStandaloneServerForBuffer',
  ':RustUnsetInlayHints',
  ':RustViewCrateGraph',
}

M.rust_command_menu = function()

end

return M
