local editor = {}

editor["danymat/neogen"] = {
	lazy = true,
	cmd = { "Neogen" },
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = require("configs.editor.neogen"),
}

editor["kevinhwang91/nvim-hlslens"] = {
	lazy = true,
	event = "SearchWrapped",
	config = require("configs.editor.nvim-hlslens"),
}

editor["kylechui/nvim-surround"] = {
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "InsertEnter",
	config = require("configs.editor.nvim-surround"),
}

return editor
