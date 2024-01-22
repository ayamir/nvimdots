return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
		misc = require("modules.utils.icons").get("misc"),
		git = require("modules.utils.icons").get("git", true),
		cmp = require("modules.utils.icons").get("cmp", true),
	}

	require("which-key").register({
		["<leader>"] = {
			b = {
				name = icons.ui.Buffer .. " Buffer",
			},
			d = {
				name = icons.ui.Bug .. " Debug",
			},
			f = {
				name = icons.ui.Telescope .. " Fuzzy Find",
			},
			g = {
				name = icons.git.Git .. "Git",
			},
			l = {
				name = icons.misc.LspAvailable .. " Lsp",
			},
			n = {
				name = icons.ui.FolderOpen .. " Nvim Tree",
			},
			p = {
				name = icons.ui.Package .. " Package",
			},
			s = {
				name = icons.cmp.tmux .. "Session",
			},
		},
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
