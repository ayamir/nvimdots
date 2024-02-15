local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	["n|<leader>q"] = map_cr("quit"):with_noremap():with_silent():with_desc("Quit buffer"),
	["n|<leader>2"] = map_cr("write"):with_noremap():with_silent():with_desc("Write buffer"),
}
