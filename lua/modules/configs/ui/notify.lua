return function()
	local notify = require("notify")
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics"),
		ui = require("modules.utils.icons").get("ui"),
	}

	require("modules.utils").load_plugin("notify", {
		stages = "fade",
		render = "default",
		fps = 20,
		timeout = 2000,
		minimum_width = 50,
		background_colour = "NotifyBackground",
		icons = {
			ERROR = icons.diagnostics.Error,
			WARN = icons.diagnostics.Warning,
			INFO = icons.diagnostics.Information,
			DEBUG = icons.ui.Bug,
			TRACE = icons.ui.Pencil,
		},
		on_open = function(win)
			vim.api.nvim_set_option_value("winblend", 0, { scope = "local", win = win })
			vim.api.nvim_win_set_config(win, { zindex = 90 })
		end,
		-- notifications with level lower than this would be ignored. [ERROR > WARN > INFO > DEBUG > TRACE]
		level = "INFO",
	})

	vim.notify = notify
end
