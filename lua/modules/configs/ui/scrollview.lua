return function()
	local icons = { diagnostics = require("modules.utils.icons").get("diagnostics", true) }

	require("scrollview").setup({
		scrollview_mode = "virtual",
		excluded_filetypes = { "NvimTree", "terminal", "nofile" },
		winblend = 0,
		signs_on_startup = { "diagnostics", "folds", "marks", "search", "spell" },
		diagnostics_error_symbol = icons.diagnostics.Error,
		diagnostics_warn_symbol = icons.diagnostics.Warning,
		diagnostics_info_symbol = icons.diagnostics.Information,
		diagnostics_hint_symbol = icons.diagnostics.Hint,
	})
end
