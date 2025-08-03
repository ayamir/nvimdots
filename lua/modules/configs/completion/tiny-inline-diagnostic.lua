return function()
	require("modules.utils").load_plugin("tiny-inline-diagnostic", {
		preset = "simple",
		options = {
			show_source = {
				enabled = true,
				if_many = true,
			},
			add_messages = true,
			set_arrow_to_diag_color = false,
			use_icons_from_diagnostic = true,
			show_all_diags_on_cursorline = false,
			break_line = {
				enabled = true,
				after = 80,
			},
			-- Filter severities up to the diagnostics level setting
			severity = vim.tbl_filter(function(level)
				return level <= vim.diagnostic.severity[require("core.settings").diagnostics_level]
			end, {
				vim.diagnostic.severity.ERROR,
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.INFO,
				vim.diagnostic.severity.HINT,
			}),
		},
		disabled_ft = {
			"alpha",
			"checkhealth",
			"dap-repl",
			"diff",
			"help",
			"log",
			"notify",
			"NvimTree",
			"Outline",
			"qf",
			"TelescopePrompt",
			"toggleterm",
			"undotree",
			"vimwiki",
		},
	})

	-- After setup, turn inline diagnostics on or off based on the `diagnostics_virtual_lines` setting
	require("tiny-inline-diagnostic")[require("core.settings").diagnostics_virtual_lines and "enable" or "disable"]()
end
