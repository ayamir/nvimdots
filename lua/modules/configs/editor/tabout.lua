return function()
	require("tabout").setup({
		tabkey = "", -- key to trigger tabout, set to an empty string to disable
		backwards_tabkey = "", -- key to trigger backwards tabout, set to an empty string to disable
		act_as_tab = true, -- shift content if tab out is not possible
		act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
		enable_backwards = true,
		completion = true, -- if the tabkey is used in a completion pum
		tabouts = {
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
		},
		ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
		exclude = {}, -- tabout will ignore these filetypes
	})
end
