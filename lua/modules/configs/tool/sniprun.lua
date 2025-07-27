return function()
	require("modules.utils").load_plugin("sniprun", {
		borders = "single",
		inline_messages = 0,
		interpreter_options = {},
		display = {
			"Classic", -- "display results in the command-line area
			"VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
			"VirtualTextErr", -- "display error results as virtual text
			-- "TempFloatingWindow", -- "display results in a floating window
			"LongTempFloatingWindow", -- "same as above, but only long results. To use with VirtualText
			-- "Terminal"                 -- "display results in a vertical split
		},
	})
end
