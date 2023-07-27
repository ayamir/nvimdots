local M = {}

local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd

local did_load_debug_mappings = false
local debug_keymap = {
	["nv|K"] = map_cmd("<Cmd>lua require('dapui').eval()<CR>")
		:with_noremap()
		:with_nowait()
		:with_desc("debug: Evaluate expression under cursor"),
}
local original_keymap = {
	["n|K"] = map_cr("Lspsaga hover_doc"):with_noremap():with_silent():with_desc("lsp: Show doc"),
	["v|K"] = map_cmd(":m '<-2<CR>gv=gv"),
}

function M.load()
	if not did_load_debug_mappings then
		bind.nvim_load_mapping(debug_keymap)
		did_load_debug_mappings = true
	end
end

function M.restore()
	if did_load_debug_mappings then
		bind.nvim_load_mapping(original_keymap)
		did_load_debug_mappings = false
	end
end

return M
