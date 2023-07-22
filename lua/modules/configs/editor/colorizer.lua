local M = {}

M["opts"] = function()
	return {}
end

M["config"] = function(_, opts)
	require("colorizer").setup(opts)
end

return M