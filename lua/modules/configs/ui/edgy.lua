return function()
	local trouble_filter = function(position)
		return function(_, win)
			return vim.w[win].trouble
				and vim.w[win].trouble.position == position
				and vim.w[win].trouble.type == "split"
				and vim.w[win].trouble.relative == "editor"
				and not vim.w[win].trouble_preview
		end
	end

	require("modules.utils").load_plugin("edgy", {
		animate = {
			enabled = true,
		},
		wo = {
			winbar = false,
		},
		exit_when_last = true,
		close_when_all_hidden = true,
		keys = {
			["q"] = false,
			["Q"] = false,
			["<c-q>"] = false,
			["za"] = function(win)
				win:toggle()
			end,
			["<A-i>"] = function(win)
				win:next({ focus = true })
			end,
			["<A-o>"] = function(win)
				win:prev({ focus = true })
			end,
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
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			{
				ft = "help",
				size = { height = 20 },
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			{
				ft = "NvimTree",
				pinned = true,
				collapsed = false,
				open = "NvimTreeOpen",
				size = {
					height = 0.5,
					width = 40,
				},
			},
		},
		right = {
			{
				ft = "trouble",
				pinned = true,
				collapsed = false,
				size = { height = 0.6, width = 0.2 },
				open = "Trouble symbols toggle win.position=right",
				filter = trouble_filter("right"),
			},
			{
				ft = "trouble",
				pinned = true,
				collapsed = true,
				size = { height = 0.4, width = 0.2 },
				open = "Trouble lsp toggle win.position=right",
				filter = trouble_filter("right"),
			},
		},
	}, false, nil, true)
end
