return function()
	local icons = {
		ts = require("modules.utils.icons").get("ts"),
	}

	require("syntax-tree-surfer").setup({
		highlight_group = "STS_highlight",
		disable_no_instance_found_report = false,
		default_desired_types = {
			"function",
			"arrow_function",
			"function_definition",
			"if_statement",
			"else_clause",
			"else_statement",
			"elseif_statement",
			"for_statement",
			"while_statement",
			"switch_statement",
		},
		left_hand_side = "fdsawervcxqtzb",
		right_hand_side = "jkl;oiu.,mpy/n",
		icon_dictionary = {
			["if_statement"] = icons.ts.IF,
			["else_clause"] = icons.ts.ELSE,
			["else_statement"] = icons.ts.ELSE,
			["elseif_statement"] = icons.ts.ELSE,
			["for_statement"] = icons.ts.FOR,
			["while_statement"] = icons.ts.WHILE,
			["switch_statement"] = icons.ts.SWITCH,
			["function"] = icons.ts.FUNC,
			["function_definition"] = icons.ts.FUNC,
			["variable_declaration"] = icons.ts.VAR,
		},
	})
end
