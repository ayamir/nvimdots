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

	-- telescope
	["n|<leader>fh"] = map_cr("Telescope help_tags"):with_noremap():with_silent():with_desc("find: help tags"),
	["n|<leader>fk"] = map_cr("Telescope keymaps"):with_noremap():with_silent():with_desc("find: keymaps"),

	["n|<C-\\>"] = map_cr("ToggleTerm dir=%:p:h direction=horizontal")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["i|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm dir=%:p:h direction=horizontal<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["t|<C-\\>"] = map_cmd("<Cmd>ToggleTerm dir=%:p:h<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle horizontal"),
	["n|<A-\\>"] = map_cr("ToggleTerm direction=vertical")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["i|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm dir=%:p:h direction=vertical<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["t|<A-\\>"] = map_cmd("<Cmd>ToggleTerm dir=%:p:h<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["n|<F5>"] = map_cr("ToggleTerm dir=%:p:h direction=vertical")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["i|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm dir=%:p:h direction=vertical<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["t|<F5>"] = map_cmd("<Cmd>ToggleTerm dir=%:p:h<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle vertical"),
	["n|<A-d>"] = map_cr("ToggleTerm dir=%:p:h direction=float")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
	["i|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm dir=%:p:h direction=float<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
	["t|<A-d>"] = map_cmd("<Cmd>ToggleTerm dir=%:p:h<CR>")
		:with_noremap()
		:with_silent()
		:with_desc("terminal: Toggle float"),
}
