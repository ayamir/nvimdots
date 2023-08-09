local plug_map = {}

plug_map = vim.tbl_extend(
	"force",
	plug_map,
	require("user.keymap.completion").plug_map,
	require("user.keymap.editor"),
	require("user.keymap.lang"),
	require("user.keymap.tool"),
	require("user.keymap.ui").plug_map
)
-- for k, v in pairs(plug_map) do
-- 	print(k, v)
-- end
--
return plug_map
