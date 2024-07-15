return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics"),
		ui = require("modules.utils.icons").get("ui"),
	}

	require("modules.utils").load_plugin("todo-comments", {
		signs = false, -- show icons in the signs column
		keywords = {
			FIX = {
				icon = icons.ui.Bug,
				color = "error",
				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
			},
			TODO = { icon = icons.ui.Accepted, color = "info" },
			-- HACK = { icon = icons.ui.Fire, color = "warning" },
			WARN = { icon = icons.diagnostics.Warning, color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = icons.ui.Perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = icons.ui.Note, color = "hint", alt = { "INFO" } },
			TEST = { icon = icons.ui.Lock, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
		},
		gui_style = {
			fg = "NONE",
			bg = "BOLD",
		},
		merge_keywords = true,
		highlight = {
			multiline = false,
			keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty.
			after = "",
			comments_only = true,
			max_line_len = 500,
			exclude = {
				"alpha",
				"bigfile",
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
			},
		},
		colors = {
			error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
			warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
			info = { "DiagnosticInfo", "#2563EB" },
			hint = { "DiagnosticHint", "#F5C2E7" },
			default = { "Conditional", "#7C3AED" },
		},
	})
end
