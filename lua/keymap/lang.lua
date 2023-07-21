local bind = require("keymap.bind")
local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

local safe_call_nabla = function()
	local nabla_ok, _ = pcall(vim.cmd, [[:lua require('nabla').popup({ border = 'rounded' })]])
	if not nabla_ok then
		vim.error("Put cursor inside latex expression")
	end
end

local plug_map = {
	-- Plugin MarkdownPreview
	["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),
	["n|<leader>0"] = map_callback(safe_call_nabla):with_noremap():with_silent():with_desc("tool: Preview markdown"),
}

bind.nvim_load_mapping(plug_map)
