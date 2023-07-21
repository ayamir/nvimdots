return function()
	require("edgy").setup({
		exit_when_last = true,
		animate = { enabled = false },
		wo = {
			-- Setting to `true`, will add an edgy winbar.
			-- Setting to `false`, won't set any winbar.
			-- Setting to a string, will set the winbar to that string.
			winbar = true,
			winfixwidth = true,
			winfixheight = false,
            winhighlight = "",
			-- winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
			spell = false,
			signcolumn = "no",
		},
		bottom = {
			-- toggleterm / lazyterm at the bottom with a height of 40% of the screen
			{
				ft = "toggleterm",
				size = { height = 0.2 },
				-- exclude floating windows
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			{
				ft = "code_runner_term",
				size = { height = 0.2 },
				-- exclude floating windows
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			"Trouble",
			{ ft = "qf", title = "QuickFix" },
			{ ft = "fugitive", title = "Git" },
			{
				ft = "help",
				size = { height = 0.25 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
			-- { ft = "spectre_panel", size = { height = 0.4 } },
		},
		right = {
			"VistaNvim",
		},
		left = {
			-- Neo-tree filesystem always takes half the screen height
			{
				title = "Neo-Tree",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				size = { height = 0.5 },
			},
			-- {
			--     title = "Neo-Tree Buffers",
			--     ft = "neo-tree",
			--     filter = function(buf)
			--         return vim.b[buf].neo_tree_source == "buffers"
			--             and vim.api.nvim_win_get_config(win).relative == ""
			--     end,
			--     pinned = true,
			--     open = "Neotree position=top buffers",
			-- },
			-- {
			--     title = "Neo-Tree Git",
			--     ft = "neo-tree",
			--     filter = function(buf)
			--         return vim.b[buf].neo_tree_source == "git_status"
			--     end,
			--     pinned = true,
			--     open = "Neotree position=right git_status",
			-- },
			-- -- any other neo-tree windows
			-- "neo-tree",
		},
		icons = {
			closed = " ",
			open = " ",
		},
		fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
	})
end
