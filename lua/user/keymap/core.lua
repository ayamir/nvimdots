local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd

return {
	-- 更方便地向下/上滚动
	-- ["n|<leader>u"] = map_cmd("<C-u>"):with_noremap():with_silent():with_nowait():with_desc("tool: scroll up"),
	-- ["n|<leader>d"] = map_cmd("<C-d>"):with_noremap():with_silent():with_nowait():with_desc("tool: scroll down/debug"),

	-- 切换标签页
	["n|L"] = map_cr("BufferLineCycleNext")
		:with_noremap()
		:with_silent()
		:with_nowait()
		:with_desc("buffer: Switch to next"),
	["n|H"] = map_cr("BufferLineCyclePrev")
		:with_noremap()
		:with_silent()
		:with_nowait()
		:with_desc("buffer: Switch to prev"),

	-- 快速移动一行
	-- Normal mode
	["n|<A-j>"] = map_cmd(":m .+1<CR>=="):with_desc("edit: Move this line down"),
	["n|<A-k>"] = map_cmd(":m .-2<CR>=="):with_desc("edit: Move this line up"),
	["n|<"] = map_cmd("<<"):with_desc("edit: Decrease indent"),
	["n|>"] = map_cmd(">>"):with_desc("edit: Increase indent"),
	-- Visual mode
	["v|<A-k>"] = map_cmd(":m '<-2<CR>gv=gv"):with_desc("edit: Move this line up"),
	["v|<A-j>"] = map_cmd(":m '>+1<CR>gv=gv"):with_desc("edit: Move this line down"),
}
