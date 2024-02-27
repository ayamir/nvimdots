local tool = {}

tool["brglng/vim-im-select"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("configs.tool.im-select"), -- Require that config
}

return tool
