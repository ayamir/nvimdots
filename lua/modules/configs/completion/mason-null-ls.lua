local M = {}

M.setup = function()
	require("modules.utils").load_plugin("mason-null-ls", {
		ensure_installed = require("core.settings").null_ls_deps,
		automatic_installation = false,
		automatic_setup = true,
		handlers = {},
	})
end

return M
