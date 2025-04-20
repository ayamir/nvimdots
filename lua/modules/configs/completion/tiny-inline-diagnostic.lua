return function()
	require("modules.utils").load_plugin("tiny-inline-diagnostic", {
		preset = "modern",
		options = {
			show_source = {
				enabled = true,
				if_many = true,
			},
			use_icons_from_diagnostic = true,
			break_line = {
				enabled = true,
			},
		},
	})
end
