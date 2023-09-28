return function()
	require("modules.utils").load_plugin("ibl", {
		enabled = true,
		debounce = 200,
		viewport_buffer = {
			min = 30,
			max = 500,
		},
		indent = {
			char = "│",
			tab_char = "┃",
			highlight = { "Function", "Label" }, -- hl-IblIndent
			smart_indent_cap = false,
			priority = 2,
			-- whitespace = {},
		},
		whitespace = {
			highlight = { "Whitespace", "NonText" }, -- hl-IblWhitespace
			remove_blankline_trail = true,
		},
		-- Note: Scope requires treesitter to be set up
		scope = {
			enabled = true,
			char = "│",
			show_start = true,
			show_end = true,
			injected_languages = true,
			highlight = { "Function", "Label" }, -- hl-IblScope
			priority = 500,
			include = {
				node_type = {
					"^if",
					"^table",
					"block",
					"class",
					"for",
					"function",
					"if_statement",
					"import",
					"list_literal",
					"method",
					"selector",
					"type",
					"var",
					"while",
				},
			},
			-- exclude = {
			-- 	language = { "rust" },
			-- 	node_type = { lua = { "block", "chunk" } },
			-- }, -- nodes or langs
		},
		exclude = {
			filetypes = {
				"", -- for all buffers without a file type
				"dashboard",
				"dotooagenda",
				"flutterToolsOutline",
				"fugitive",
				"git",
				"gitcommit",
				"help",
				"json",
				"log",
				"markdown",
				"NvimTree",
				"peekaboo",
				"startify",
				"TelescopePrompt",
				"todoist",
				"txt",
				"undotree",
				"text",
				"vimwiki",
				"vista",
			},
			buftypes = { "terminal", "nofile", "quickfix", "prompt" },
		},
	})
end
