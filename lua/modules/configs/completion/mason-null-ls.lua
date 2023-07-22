local M = {}

M["opts"] = function()
	return {
		ensure_installed = require("core.settings").null_ls_deps,
		automatic_installation = false,
		automatic_setup = true,
		handlers = {},
	}
end

M["config"] = function(_, opts)
	require("mason-null-ls").setup(opts)
end

return M