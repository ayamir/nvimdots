local ui = {}

ui["yucao16/dashboard-nvim"] = {
	lazy = true,
	event = "BufWinEnter",
	config = require("ui.dashboard"),
}
ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.bufferline"),
	dependencies = {
		{ "tiagovla/scope.nvim" },
	},
}
ui["Jint-lzxy/nvim"] = { -- catppuccin
	lazy = true,
	branch = "refactor/syntax-highlighting",
	name = "catppuccin",
	config = require("ui.catppuccin"),
}
ui["folke/tokyonight.nvim"] = {
	lazy = false,
}
ui["navarasu/onedark.nvim"] = {
	lazy = false,
	config = require("ui.onedark"),
}
ui["j-hui/fidget.nvim"] = {
	lazy = true,
	branch = "legacy",
	event = "LspAttach",
	config = require("ui.fidget"),
}
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.gitsigns"),
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("ui.indent-blankline"),
}
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.lualine"),
}
ui["karb94/neoscroll.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.neoscroll"),
}
ui["rcarriga/nvim-notify"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("ui.notify"),
}
ui["folke/paint.nvim"] = { -- Easily add additional highlights to your buffers Topics
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("ui.paint"),
}
ui["petertriho/nvim-scrollbar"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("ui.scroll_bar"),
}
ui["folke/zen-mode.nvim"] = {
	lazy = true,
	cmd = { "ZenMode" },
	config = require("ui.zenmode"),
}
ui["dvoytik/hi-my-words.nvim"] = {
	lazy = true,
	config = true,
	cmd = { "HiMyWordsToggle", "HiMyWordsClear" },
	event = { "VeryLazy" },
}
ui["machakann/vim-highlightedyank"] = {
	lazy = true,
	event = { "VeryLazy" },
}
ui["kevinhwang91/nvim-bqf"] = {
	lazy = true,
	config = true,
	ft = { "qf" },
}
ui["lvimuser/lsp-inlayhints.nvim"] = {
	lazy = true,
	event = { "LspAttach" },
	config = require("ui.inlay_hint"),
}
ui["itchyny/vim-highlighturl"] = {
	lazy = true,
	event = "BufReadPost",
	config = function()
		vim.g.highlighturl_guifg = "#8AB4F8"
	end,
}
ui["stevearc/dressing.nvim"] = {
	lazy = false,
	config = require("ui.dressing_config"),
}

return ui
