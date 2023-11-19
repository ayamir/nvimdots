return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui"),
	}

	require("modules.utils").load_plugin("fidget", {
		progress = {
			suppress_on_insert = false, -- Suppress new messages while in insert mode
			ignore_done_already = false, -- Ignore new tasks that are already complete
			ignore = { "null-ls" }, -- List of LSP servers to ignore
			display = {
				render_limit = 5, -- How many LSP messages to show at once
				done_ttl = 2, -- How long a message should persist after completion
				done_icon = icons.ui.Accepted, -- Icon shown when all LSP progress tasks are complete
			},
		},
		notification = {
			override_vim_notify = false, -- Automatically override vim.notify() with Fidget
			window = {
				winblend = 0, -- Background color opacity in the notification window
				zindex = 75, -- Stacking priority of the notification window
			},
		},
	})
end
