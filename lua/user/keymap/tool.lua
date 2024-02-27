local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	-- Remove default keymap
	-- ["n|<leader>nf"] = "",
	-- ["n|<leader>nr"] = false,
	-- Plugin: telescope
    ["n|<leader>L"] = map_cr("Lazy"):with_noremap():with_silent(),
}