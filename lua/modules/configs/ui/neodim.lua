return function()
	local blend_color = require("modules.utils").gen_neodim_blend_attr()

	require("modules.utils").load_plugin("neodim", {
		alpha = 0.45,
		blend_color = blend_color,
		refresh_delay = 75, -- time in ms to wait after typing before refreshing diagnostics
		hide = {
			virtual_text = true,
			signs = false,
			underline = false,
		},
		priority = 80,
		disable = {
			"alpha",
			"bigfile",
			"checkhealth",
			"dap-repl",
			"diff",
			"fugitive",
			"fugitiveblame",
			"git",
			"gitcommit",
			"help",
			"log",
			"notify",
			"NvimTree",
			"Outline",
			"qf",
			"TelescopePrompt",
			"text",
			"toggleterm",
			"undotree",
			"vimwiki",
		},
	})
end
