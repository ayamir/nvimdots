return function()
	local apairs_ok, apairs = pcall(require, "nvim-autopairs")
	if not apairs_ok then
		vim.notify("nvim-autopairs failed", "error", { render = "minimal" })
		return
	end

	apairs.setup({
		check_ts = true,
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			jave = false,
		},
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0,
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "PmenuSel",
			highlight_grey = "LineNr",
		},
	})

	local cond = require("nvim-autopairs.conds")
	local Rule = require("nvim-autopairs.rule")
	local latex = { "tex", "latex" }
	apairs.add_rules(
		{
			Rule("```", "```", { "typst", "typ", "markdown", "vimwiki", "rmarkdown", "rmd", "pandoc" }),
			Rule("```.*$", "```", { "typst", "typ", "markdown", "vimwiki", "rmarkdown", "rmd", "pandoc" })
				:only_cr()
				:use_regex(true),
			Rule("\\(", "  \\)", latex):set_end_pair_length(3),
			Rule("\\[", "  \\]", latex):set_end_pair_length(3),
			Rule("$", "  $", { "tex", "latex", "markdown" })
				:set_end_pair_length(2)
				-- don't add a pair if the next character is %
				:with_pair(cond.not_after_regex("%%"))
				-- don't add a pair if  the previous character is xxx
				:with_pair(cond.not_before_regex("xxx", 3))
				-- don't move right when repeat character
				:with_move(cond.none())
				-- don't delete if the next character is xx
				:with_del(cond.not_after_regex("xx"))
				-- disable adding a newline when you press <cr>
				:with_cr(cond.none()),
		},
		-- disable for .vim files, but it work for another filetypes
		Rule("a", "a", "-vim")
	)

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local cmp_ok, cmp = pcall(require, "cmp")
	if not cmp_ok then
		return
	end
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { text = "" } }))
end
