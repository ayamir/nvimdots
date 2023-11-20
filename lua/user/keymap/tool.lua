local bind = require("keymap.bind")
local map_cr = bind.map_cr
return {
	-- Plugin: nvim-tree
	["n|<leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
}
