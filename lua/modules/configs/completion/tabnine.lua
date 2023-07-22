local M = {}

M["opts"] = function()
	return { max_line = 1000, max_num_results = 20, sort = true }
end

M["config"] = function(_, opts)
	require("cmp_tabnine.config"):setup(opts)
end

return M