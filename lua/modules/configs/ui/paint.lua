return function()
	require("modules.utils").load_plugin("paint", {
		highlights = {
			{
				filter = { filetype = "lua" },
				pattern = "%s*%-%-%-%s*(@%w+)",
				hl = "Constant",
			},
			{
				filter = { filetype = "python" },
				pattern = "%s*([_%w]+:)",
				hl = "Constant",
			},
		},
	})
end
