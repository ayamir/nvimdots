local M = {}

M["opts"] = function()
	return {}
end

M["config"] = function()
	require("codeium").setup({})
end

return M