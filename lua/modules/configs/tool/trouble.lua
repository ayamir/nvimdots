return function()
	local icons = {
		ui = require("modules.utils.icons").get("ui", true),
	}

	require("modules.utils").load_plugin("trouble", {
		auto_open = false,
		auto_close = false,
		auto_jump = false,
		auto_preview = true,
		auto_refresh = true,
		focus = false, -- do not focus the window when opened
		follow = true,
		restore = true,
		icons = {
			indent = {
				fold_open = icons.ui.ArrowOpen,
				fold_closed = icons.ui.ArrowClosed,
			},
			folder_closed = icons.ui.Folder,
			folder_open = icons.ui.FolderOpen,
		},
		modes = {
			project_diagnostics = {
				mode = "diagnostics",
				filter = {
					any = {
						{
							function(item)
								return item.filename:find(vim.fn.getcwd(), 1, true)
							end,
						},
					},
				},
			},
		},
	})
end
