return function()
	require("modules.utils").load_plugin("nvim-highlight-colors", {
		render = "background",
		enable_hex = true,
		enable_short_hex = true,
		enable_rgb = true,
		enable_hsl = true,
		enable_var_usage = true,
		enable_named_colors = false,
		enable_tailwind = false,
		-- Exclude filetypes or buftypes from highlighting
		exclude_filetypes = {
			"alpha",
			"bigfile",
			"dap-repl",
			"fugitive",
			"git",
			"notify",
			"NvimTree",
			"Outline",
			"TelescopePrompt",
			"toggleterm",
			"undotree",
		},
		exclude_buftypes = {
			"nofile",
			"prompt",
			"terminal",
		},
	})
end
