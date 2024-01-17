local icons = {
	ui_sep = require("modules.utils.icons").get("ui", true),
	misc_sep = require("modules.utils.icons").get("misc", true),
	git_sep = require("modules.utils.icons").get("git", true),
	cmp_sep = require("modules.utils.icons").get("cmp", true),
}

--- Need to expand by hand
local prefix_desc = {
	["<leader>b"] = icons.ui_sep.Buffer .. "Buffer",
	["<leader>d"] = icons.ui_sep.Bug .. "Debug",
	["<leader>f"] = icons.ui_sep.Telescope .. "Fuzzy Find",
	["<leader>g"] = icons.git_sep.Git .. "Git",
	["<leader>l"] = icons.misc_sep.LspAvailable .. "Lsp",
	["<leader>n"] = icons.ui_sep.FolderOpen .. "Nvim Tree",
	["<leader>p"] = icons.ui_sep.Package .. "Package",
	["<leader>s"] = icons.cmp_sep.tmux .. "Session",
}

return prefix_desc
