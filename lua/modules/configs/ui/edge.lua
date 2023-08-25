return function()
	vim.g.edge_style = "aura"
	vim.g.edge_enable_italic = 1
	vim.g.edge_disable_italic_comment = 1
	vim.g.edge_show_eob = 1
	vim.g.edge_better_performance = 1
	vim.g.edge_transparent_background = require("core.settings").transparent_background and 2 or 0

	require("modules.utils").load_plugin("edge", nil, true)
end
