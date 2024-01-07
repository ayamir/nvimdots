local keymap = require("modules.utils.keymap")

local maps = keymap.empty_map_table()

local icons = {
	ui_sep = require("modules.utils.icons").get("ui", true),
}

local sections = {
	b = { desc = icons.ui_sep.Buffer .. "Buffer" },
}

maps.n["<leader>b"] = sections.b

keymap.set_mappings(maps)
