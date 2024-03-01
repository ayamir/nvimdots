local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {
	-- Remove default keymap
	-- ["n|<leader>nf"] = "",
	-- ["n|<leader>nr"] = false,
	["n|<leader>E"] = map_cr("e ~/.config/nvim/init.lua"):with_noremap():with_silent(),

	-- Insert
	["i|;"] = map_cmd("<esc>"),
	["i|<C-e>"] = map_cmd("<esc>A"),
	["i|<C-a>"] = map_cmd("<esc>I"),
	["i|<C-b>"] = map_cmd("<Left>"):with_noremap(),
	["i|<C-f>"] = map_cmd("<Right>"):with_noremap(),

	["n|Y"] = map_cmd("y$"),
	["n|D"] = map_cmd("d$"),
	["n|L"] = map_cmd("$"),
	["n|H"] = map_cmd("^"),
	-- -- ["n|S"] = map_cr("w"),
	["n|S"] = map_cmd(":w<CR>"),
	["n|Q"] = map_cmd(":q<CR>"),

	-- Visual
	["v|J"] = map_cmd(":m '>+1<cr>gv=gv"),
	["v|K"] = map_cmd(":m '<-2<cr>gv=gv"),
	["v|<"] = map_cmd("<gv"),
	["v|>"] = map_cmd(">gv"),
	["v|L"] = map_cmd("$"),
	["v|H"] = map_cmd("^"),
	["v|p"] = map_cmd('"_dP'),
}
