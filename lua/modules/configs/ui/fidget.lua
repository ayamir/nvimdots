return function()
	require("modules.utils").load_plugin("fidget", {
		window = { blend = 0 },
		sources = {
			["null-ls"] = { ignore = true },
		},
		fmt = {
			max_messages = 3, -- The maximum number of messages stacked at any give time
		},
	})
end
