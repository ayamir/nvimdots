local M = {}

M["opts"] = function()
	return { keys = "etovxqpdygfblzhckisuran" }
end

M["config"] = function(_, opts)
	require("hop").setup(opts)
end

return M