local M = {}

M["opts"] = function()
	return {
		window = { blend = 0 },
		sources = {
			["null-ls"] = { ignore = true },
		},
		fmt = {
			max_messages = 3, -- The maximum number of messages stacked at any give time
		},
	}
end

M["opts"] = function(_, opts)
	require("fidget").setup(opts)
end

return M