local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	["n|<C-n>"] = "",
	["n|<C-n>"] = map_cr("Neotree toggle"):with_noremap():with_silent():with_desc("filetree: Toggle"),
	["n|<leader>nf"] = "",
	["n|<leader>nr"] = "",
	["n|<leader>hpb"] = map_callback(function()
		require("plenary.profile").start("profile.log", { flame = true })
	end),
	["n|<leader>hps"] = map_callback(function()
		require("plenary.profile").stop()
	end),
}
