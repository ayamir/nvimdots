return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
		misc = require("modules.utils.icons").get("misc"),
	}

	require("which-key").add({
		{ "<leader>S", group = "Search" },
		{ "<leader>W", group = "Window" },
		{ "<leader>b", group = "Buffer" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Fuzzy Find", icon = icons.ui.Telescope },
		{ "<leader>g", group = "Git" },
		{ "<leader>l", group = "Lsp", icon = icons.misc.LspAvailable },
		{ "<leader>n", group = "Nvim Tree", icon = icons.ui.FolderOpen },
		{ "<leader>p", group = "Package", icon = icons.ui.Package },
		{ "<leader>s", group = "Session" },
	})

	require("modules.utils").load_plugin("which-key", {
		plugins = {
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = true,
				g = true,
			},
		},

		icons = {
			breadcrumb = icons.ui.Separator,
			separator = icons.misc.Vbar,
			group = "",
		},

		window = {
			border = "none",
			position = "bottom",
			margin = { 1, 0, 1, 0 },
			padding = { 1, 1, 1, 1 },
			winblend = 0,
		},
	})
end
