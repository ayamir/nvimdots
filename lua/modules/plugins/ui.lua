local ui = {}

ui["goolord/alpha-nvim"] = {
	lazy = true,
	event = "BufWinEnter",
	opts = require("ui.alpha").opts,
	config = require("ui.alpha").config,
}
ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	opts = require("ui.bufferline").opts,
	config = require("ui.bufferline").config,
}
ui["Jint-lzxy/nvim"] = {
	lazy = false,
	branch = "refactor/syntax-highlighting",
	name = "catppuccin",
	opts = require("ui.catppuccin").opts,
	config = require("ui.catppuccin").config,
}
ui["sainnhe/edge"] = {
	lazy = true,
	opts = require("ui.edge").opts,
	config = require("ui.edge").config,
}
ui["j-hui/fidget.nvim"] = {
	lazy = true,
	branch = "legacy",
	event = "LspAttach",
	opts = require("ui.fidget").opts,
	config = require("ui.fidget").config,
}
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("ui.gitsigns").opts,
	config = require("ui.gitsigns").config,
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	opts = require("ui.indent-blankline").opts,
	config = require("ui.indent-blankline").config,
}
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	opts = require("ui.lualine").opts,
	config = require("ui.lualine").config,
}
ui["zbirenbaum/neodim"] = {
	lazy = true,
	event = "LspAttach",
	opts = require("ui.neodim").opts,
	config = require("ui.neodim").config,
}
ui["karb94/neoscroll.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("ui.neoscroll").opts,
	config = require("ui.neoscroll").config,
}
ui["shaunsingh/nord.nvim"] = {
	lazy = true,
	opts = require("ui.nord").opts,
	config = require("ui.nord").config,
}
ui["rcarriga/nvim-notify"] = {
	lazy = true,
	event = "VeryLazy",
	opts = require("ui.notify").opts,
	config = require("ui.notify").config,
}
ui["folke/paint.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	opts = require("ui.paint").opts,
	config = require("ui.paint").config,
}
ui["dstein64/nvim-scrollview"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	opts = require("ui.scrollview").opts,
	config = require("ui.scrollview").config,
}
ui["edluffy/specs.nvim"] = {
	lazy = true,
	event = "CursorMoved",
	opts = require("ui.specs").opts,
	config = require("ui.specs").config,
}

return ui