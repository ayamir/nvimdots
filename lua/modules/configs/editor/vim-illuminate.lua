return function()
	require("modules.utils").load_plugin("vim-illuminate", {
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		delay = 100,
		filetypes_denylist = {
			"DoomInfo",
			"DressingSelect",
			"NvimTree",
			"Outline",
			"TelescopePrompt",
			"Trouble",
			"alpha",
			"dashboard",
			"dirvish",
			"fugitive",
			"help",
			"lsgsagaoutline",
			"neogitstatus",
			"norg",
			"toggleterm",
		},
		under_cursor = false,
	}, false, require("illuminate").configure)
end
