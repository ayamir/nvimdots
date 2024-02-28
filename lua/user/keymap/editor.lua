local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback

return {

	["n|<leader>/"] = map_cmd([[<Plug>(comment_toggle_linewise_current)]]):with_silent(),
	["v|<leader>/"] = map_cmd([[<Plug>(comment_toggle_linewise_current)]]):with_silent(),
}
