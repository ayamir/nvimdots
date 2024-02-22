local bind = require("keymap.bind")
local map_cr = bind.map_cr

return {
	["n|<leader>b"] = map_cr("BufferLineSortByExtension"):with_noremap():with_desc("buffer: Sort"),
	["n|<leader>h"] = map_cr("BufferLineSortByExtension"):with_noremap():with_desc("git: Info"),

}
