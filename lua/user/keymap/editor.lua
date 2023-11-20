local bind = require("keymap.bind")
local map_cr = bind.map_cr

return {
	-- Plugin: nvim-bufdel
	["n|<leader>x"] = map_cr("BufDel"):with_noremap():with_silent():with_desc("buffer: Close current"),
	["n|<leader>v"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("git: Show diff"),
	["n|<leader>V"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("git: Close diff"),
}
