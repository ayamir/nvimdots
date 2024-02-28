local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	-- Remove default keymap
	-- ["n|<leader>nf"] = "",
	-- ["n|<leader>nr"] = false,
	-- Plugin: telescope
	["n|<leader><S-cr>"] = map_callback(function()
			_command_panel()
		end)
		:with_noremap()
		:with_silent()
		:with_desc("tool: Toggle command panel"),
	["n|<leader>fh"] = map_cr("Telescope help_tags"):with_noremap():with_silent():with_desc("find: help tags"),
	["n|<leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
}
