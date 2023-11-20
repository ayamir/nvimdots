local bind = require("keymap.bind")
local map_cu = bind.map_cu
local map_callback = bind.map_callback
local map_cr = bind.map_cr
return {
	-- Plugin: nvim-tree
	["n|<leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
	-- Plugin: telescope
	["n|<leader>fk"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),

	["n|<leader>ui"] = map_cu("Telescope colorscheme"):with_noremap():with_silent():with_desc("ui: Change colorscheme for current session"),
}
