return function()
	require("modules.utils").load_plugin("edgy", {
		close_when_all_hidden = true,
		exit_when_last = true,
		wo = { winbar = false },
		keys = {
			["q"] = false,
			["Q"] = false,
			["<C-q>"] = false,
			["<A-j>"] = function(win)
				win:resize("height", -2)
			end,
			["<A-k>"] = function(win)
				win:resize("height", 2)
			end,
			["<A-h>"] = function(win)
				win:resize("width", -2)
			end,
			["<A-l>"] = function(win)
				win:resize("width", 2)
			end,
		},
		bottom = {
			{ ft = "qf", size = { height = 0.3 } },
			{
				ft = "toggleterm",
				size = { height = 0.3 },
				filter = function(_, win)
					return vim.w[win].relative == ""
				end,
			},
			{
				ft = "help",
				size = { height = 0.3 },
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			{
				ft = "NvimTree",
				pinned = true,
				open = "NvimTreeOpen",
				size = { width = 30 },
			},
		},
		right = {
			{
				ft = "aerial",
				pinned = true,
				open = "AerialToggle!",
			},
		},
	})
end
