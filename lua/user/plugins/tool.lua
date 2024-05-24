local tool = {}

tool["numToStr/Navigator.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("configs.tool.navigator"),
}

tool["skywind3000/asyncrun.vim"] = {
	lazy = true,
	cmd = { "AsyncRun", "Rungnome" },
	config = require("configs.tool.asyncrun"),
	dependencies = {
		"preservim/vimux",
		config = require("configs.tool.vimux"),
	},
}

tool["skywind3000/asynctasks.vim"] = {
	lazy = true,
	cmd = { "AsyncTask", "AsyncTaskList", "AsyncTaskEdit" },
	config = require("configs.tool.asynctask"),
}

tool["nvim-neo-tree/neo-tree.nvim"] = {
	lazy = true,
	cmd = {
		"Neotree",
	},
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = require("configs.tool.neo-tree"),
}

tool["wintermute-cell/gitignore.nvim"] = {
	lazy = true,
	requires = {
		"nvim-telescope/telescope.nvim", -- optional: for multi-select
	},
	cmd = {
		"Gitignore",
	},
}

tool["askfiy/nvim-picgo"] = {
	lazy = true,
	ft = { "markdown" },
	config = require("configs.tool.picgo"),
}

tool["keaising/im-select.nvim"] = {
	lazy = true,
	event = "InsertEnter",
	config = require("configs.tool.im-select"),
}

tool["folke/zen-mode.nvim"] = {
	lazy = false,
}

tool["CoatiSoftware/vim-sourcetrail"] = {
	lazy = true,
	cmd = {
		"SourcetrailStartServer",
		"SourcetrailRestartServer",
		"SourcetrailStopServer",
	},
	config = function()
		vim.g.sourcetrail_ip = "127.0.0.1"
		vim.g.sourcetrail_to_vim_port = 16678
		vim.g.vim_to_sourcetrail_port = 16677
	end,
}

tool["rareitems/printer.nvim"] = {
	config = function()
		require("printer").setup({
			keymap = "gm", -- Plugin doesn't have any keymaps by default
		})
	end,
}

tool["cathaysia/jieba_nvim"] = {
	lazy = true,
	ft = { "tex", "markdown" },
	config = function()
		local jieba = require("libjiebamove")

		function _G.move_chs(isRight)
			local row = vim.api.nvim_win_get_cursor(0)[1]
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local content = vim.api.nvim_buf_get_lines(0, row - 1, row, 0)[1]
			local new_pos = jieba.getPos(content, col, isRight)
			print(new_pos)
			vim.api.nvim_win_set_cursor(0, { row, new_pos })
		end

		vim.api.nvim_set_keymap("n", "e", ":lua move_chs(1)<CR>", {})
		vim.api.nvim_set_keymap("n", "b", ":lua move_chs(0)<CR>", {})
	end,
}

tool["windwp/nvim-autopairs"] = {
	event = "InsertEnter",
	config = require("user.configs.tool.autopairs"),
}

tool["Mr-LLLLL/cool-chunk.nvim"] = {
	event = { "CursorHold", "CursorHoldI" },
	config = require("user.configs.tool.cool-chunk"),
}

return tool
