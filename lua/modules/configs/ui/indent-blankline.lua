return function()
	require("indent_blankline").setup({
		space_char_blankline = " ",
		show_current_context = true,

		filetype_exclude = {
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
			"neo-tree",
			"peekaboo",
			"startify",
			"TelescopePrompt",
			"todoist",
			"txt",
			"undotree",
			"vimwiki",
			"vista",
		},
		buftype_exclude = { "terminal", "nofile" },
		-- context_patterns = {
		-- 	"^if",
		-- 	"^table",
		-- 	"block",
		-- 	"class",
		-- 	"for",
		-- 	"function",
		-- 	"if_statement",
		-- 	"import",
		-- 	"list_literal",
		-- 	"method",
		-- 	"selector",
		-- 	"type",
		-- 	"var",
		-- 	"while",
		-- },
	})
	-- vim.g["indentLine_char"] = "▏"
	vim.g["indentLine_defaultGroup"] = "SpecialKey"
end
