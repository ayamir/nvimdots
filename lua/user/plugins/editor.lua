local editor = {}

editor["nvim-neo-tree/neo-tree.nvim"] = {
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = require("configs.editor.neo-tree"), -- Require that config
}

editor["terrortylor/nvim-comment"] = {
	cmd = "CommentToggle",
	config = require("configs.editor.nvim-comment"), -- Require that config
}

return editor
