local M = {}

M["opts"] = function()
	return {
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
	}
end

M["config"] = function()
	require("illuminate").configure()
end

return M