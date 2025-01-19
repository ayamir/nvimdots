require("keymap.helpers")
local bind = require("keymap.bind")
local map_cr = bind.map_cr

local mappings = {
	core = {
		-- Package manager: lazy.nvim
		["n|<leader>ph"] = map_cr("Lazy"):with_silent():with_noremap():with_nowait():with_desc("package: Show"),
		["n|<leader>ps"] = map_cr("Lazy sync"):with_silent():with_noremap():with_nowait():with_desc("package: Sync"),
		["n|<leader>pu"] = map_cr("Lazy update")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Update"),
		["n|<leader>pi"] = map_cr("Lazy install")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Install"),
		["n|<leader>pl"] = map_cr("Lazy log"):with_silent():with_noremap():with_nowait():with_desc("package: Log"),
		["n|<leader>pc"] = map_cr("Lazy check"):with_silent():with_noremap():with_nowait():with_desc("package: Check"),
		["n|<leader>pd"] = map_cr("Lazy debug"):with_silent():with_noremap():with_nowait():with_desc("package: Debug"),
		["n|<leader>pp"] = map_cr("Lazy profile")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Profile"),
		["n|<leader>pr"] = map_cr("Lazy restore")
			:with_silent()
			:with_noremap()
			:with_nowait()
			:with_desc("package: Restore"),
		["n|<leader>px"] = map_cr("Lazy clean"):with_silent():with_noremap():with_nowait():with_desc("package: Clean"),
	},
}

bind.nvim_load_mapping(mappings.core)

-- Builtin & Plugin keymaps
require("keymap.completion")
require("keymap.editor")
require("keymap.lang")
require("keymap.tool")
require("keymap.ui")

-- User keymaps
local ok, def = pcall(require, "user.keymap.init")
if ok then
	require("modules.utils.keymap").replace(def)
end
