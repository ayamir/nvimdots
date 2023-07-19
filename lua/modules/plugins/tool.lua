local tool = {}

tool["tpope/vim-fugitive"] = {
	lazy = true,
	cmd = { "Git", "G" },
}
tool["nvim-neo-tree/neo-tree.nvim"] = {
	lazy = true,
	cmd = { "Neotree" },
	branch = "v3.x",
	init = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			desc = "Load NeoTree if entering a directory",
			callback = function(args)
				if vim.fn.isdirectory(vim.api.nvim_buf_get_name(args.buf)) > 0 then
					require("lazy").load({ plugins = { "neo-tree.nvim" } })
					vim.api.nvim_del_autocmd(args.id)
				end
			end,
		})
	end,
	config = require("tool.neotree"),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					-- hint = "floating-big-letter",
					autoselect_one = true,
					include_current = false,
					filter_rules = {
						bo = {
							filetype = { "neo-tree-popup", "quickfix", "VistaNvim" },
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
}
tool["michaelb/sniprun"] = {
	lazy = true,
	-- You need to cd to `~/.local/share/nvim/site/lazy/sniprun/` and execute `bash ./install.sh`,
	-- if you encountered error about no executable sniprun found.
	build = "bash ./install.sh",
	cmd = { "SnipRun" },
	config = require("tool.sniprun"),
}
tool["akinsho/toggleterm.nvim"] = {
	lazy = true,
	cmd = {
		"ToggleTerm",
		"ToggleTermSetName",
		"ToggleTermToggleAll",
		"ToggleTermSendVisualLines",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualSelection",
	},
	config = require("tool.toggleterm"),
}
tool["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("tool.trouble"),
}
tool["folke/which-key.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("tool.which-key"),
}
-- tool["gelguy/wilder.nvim"] = {
-- 	lazy = true,
-- 	event = "CmdlineEnter",
-- 	config = require("tool.wilder"),
-- 	dependencies = { "romgrk/fzy-lua-native" },
-- }
tool["yucao16/registers.nvim"] = {
	lazy = false,
	config = function()
		vim.g["registers_delay"] = 200
		vim.g["registers_window_border"] = "rounded"
		vim.g["system_clip"] = 1
		vim.g["peekup_open"] = '"'
	end,
}
tool["sidebar-nvim/sidebar.nvim"] = {
	lazy = true,
	cmd = { "SidebarNvimOpen", "SidebarNvimFocus", "SidebarNvimToggle" },
	config = require("tool.sidebar"),
}
tool["akinsho/git-conflict.nvim"] = {
	event = "VeryLazy",
}
tool["NeogitOrg/neogit"] = {
	lazy = true,
	cmd = { "Neogit" },
	config = require("tool.neogit_config"),
}
tool["folke/edgy.nvim"] = {
	lazy = false,
	config = require("tool.edgy"),
}
tool["AckslD/nvim-neoclip.lua"] = {
	lazy = true,
	event = { "CmdlineEnter", "TextYankPost" },
	config = require("tool.neoclip"),
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{ "nvim-telescope/telescope.nvim" },
	},
}
tool["yucao16/vista.nvim"] = {
	lazy = true,
	event = { "LspAttach" },
	cmd = { "VistaNvimOpen", "VistaNvimToggle", "VistaNvimToggle" },
	branch = "vista.nvim-dev",
	config = require("tool.vista"),
}
tool["JellyApple102/flote.nvim"] = {
	lazy = true,
	cmd = { "Float" },
	config = require("tool.flote"),
}
tool["danymat/neogen"] = {
	lazy = true,
	cmd = { "Neogen" },
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
	},
	config = function()
		require("neogen").setup({})
	end,
}
tool["neomake/neomake"] = {
	lazy = true,
	event = { "BufAdd", "InsertEnter" },
}
tool["samjwill/nvim-unception"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("tool.unception"),
}
tool["stevearc/oil.nvim"] = {
	lazy = true,
	cmd = "Oil",
	config = require("tool.oil"),
}

----------------------------------------------------------------------
--                        Telescope Plugins                         --
----------------------------------------------------------------------
tool["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("tool.telescope"),
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-lua/plenary.nvim" },
		{ "debugloop/telescope-undo.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "LinArcX/telescope-env.nvim" },
		{ "nvim-telescope/telescope-frecency.nvim", dependencies = {
			{ "kkharji/sqlite.lua" },
		} },
		{ "jvgrootveld/telescope-zoxide" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{ "smartpde/telescope-recent-files" },
		{ "crispgm/telescope-heading.nvim" },
	},
}

----------------------------------------------------------------------
--                           DAP Plugins                            --
----------------------------------------------------------------------
tool["mfussenegger/nvim-dap"] = {
	lazy = true,
	cmd = {
		"DapSetLogLevel",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapToggleRepl",
		"DapStepOver",
		"DapStepInto",
		"DapStepOut",
		"DapTerminate",
	},
	config = require("tool.dap"),
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = require("tool.dap.dapui"),
		},
		{ "jay-babu/mason-nvim-dap.nvim" },
	},
}

return tool
