local M = {}

local bind = require("keymap.bind")
local map_cmd = bind.map_cmd

local did_load_debug_mappings = false
local debug_keymap = {
	["nv|K"] = map_cmd("<Cmd>lua require('dapui').eval()<CR>")
		:with_noremap()
		:with_nowait()
		:with_desc("Evaluate expression under cursor"),
}

function M.load_extras()
	if not did_load_debug_mappings then
		require("modules.utils.keymap").amend("Debugging", "_debugging", debug_keymap)
		did_load_debug_mappings = true
	end
end

return M
