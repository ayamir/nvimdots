return function()
	vim.g.maplocalleader = ","
	require("modules.utils").load_plugin("grug-far", {
		engine = "ripgrep",
		engines = {
			ripgrep = {
				path = "rg",
				showReplaceDiff = true,
				placeholders = {
					enabled = true,
				},
			},
		},
		windowCreationCommand = "bot split",
		disableBufferLineNumbers = false,
		icons = {
			enabled = true,
		},
	})
end
