local bind = require("keymap.bind")
local override = require("core.override")
local user_keymap = require("user.keymap.lang")
local map_cr = bind.map_cr
-- local map_cu = bind.map_cu
-- local map_cmd = bind.map_cmd
-- local map_callback = bind.map_callback

local plug_map = {
	-- Plugin MarkdownPreview
	["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),
}


plug_map = override.reset(plug_map, user_keymap.reset)
plug_map = override.merge(plug_map, user_keymap.merge)
bind.nvim_load_mapping(plug_map)