return function()
	require("modules.utils").load_plugin("edgy", {
		animate = {
			enabled = false,
		},
		wo = {
			winbar = false,
		},
		exit_when_last = true,
		close_when_all_hidden = true,
		bottom = {
			{ ft = "qf", size = { height = 0.3 } },
			{ ft = "trouble", size = { height = 0.3 } },
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
			{ ft = "NvimTree", size = { height = 0.5 } },
		},
	})
end
