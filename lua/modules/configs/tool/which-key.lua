return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
		misc = require("modules.utils.icons").get("misc")
	}

	require("modules.utils").load_plugin("which-key", {
		plugins = {
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = true,
				g = true
			}
		},

		icons = {
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			group = ""
		},

		window = {
			border = "none",
			position = "bottom",
			margin = {1, 0, 1, 0},
			padding = {1, 1, 1, 1},
			winblend = 0
		}
	})

	require("modules.utils.keymap").which_key_register()
end
