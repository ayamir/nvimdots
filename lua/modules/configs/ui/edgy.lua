return function()
	local function trouble_filter(position)
		return function(_, win)
			local tw = vim.w[win].trouble
			return tw
				and tw.position == position
				and tw.type == "split"
				and tw.relative == "editor"
				and not vim.w[win].trouble_preview
		end
	end

	require("modules.utils").load_plugin("edgy", {
		animate = { enabled = false },
		close_when_all_hidden = true,
		exit_when_last = true,
		wo = { winbar = false },
		keys = {
			q = false,
			Q = false,
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
		left = {
			{
				ft = "NvimTree",
				pinned = true,
				collapsed = false,
				size = { height = 0.6, width = 0.15 },
				open = "NvimTreeOpen",
			},
			{
				ft = "trouble",
				pinned = true,
				collapsed = false,
				size = { height = 0.4, width = 0.15 },
				open = function()
					return vim.b.buftype == "" and "Trouble symbols toggle win.position=right"
				end,
				filter = trouble_filter("right"),
			},
		},
		bottom = {
			{ ft = "qf", size = { height = 0.3 } },
			{
				ft = "toggleterm",
				size = { height = 0.3 },
				filter = function(_, win)
					local cfg = vim.api.nvim_win_get_config(win)
					local term = require("toggleterm.terminal").get(1)
					return cfg.relative == "" and term.direction == "horizontal"
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
		right = {
			{
				ft = "codecompanion",
				pinned = true,
				collapsed = false,
				size = { width = 0.25 },
				open = "CodeCompanionChat Toggle",
			},
		},
	})
end
