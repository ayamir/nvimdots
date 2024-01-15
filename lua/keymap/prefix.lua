local icons = {
	ui_sep = require("modules.utils.icons").get("ui", true),
	misc_sep = require("modules.utils.icons").get("misc", true),
	git_sep = require("modules.utils.icons").get("git", true),
}

--- Need to expand by hand
local prefix_desc = {
	["<leader>b"] = icons.ui_sep.Buffer .. "Buffer",
	["<leader>l"] = icons.misc_sep.LspAvailable .. "Lsp",
	["<leader>h"] = icons.git_sep.Git .. "Git",
}

return prefix_desc
