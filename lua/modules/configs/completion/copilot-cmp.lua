local M = {}

M["opts"] = function()
    return {}
end

M["config"] = function()
	require("copilot_cmp").setup({})
end

return M