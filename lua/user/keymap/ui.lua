local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	["n|<leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent():with_desc("Toggle NerdTree"),
	["n|<S-h>"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent():with_desc("Go to prev buffer"),
	["n|<S-l>"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent():with_desc("Go to next buffer"),
}
