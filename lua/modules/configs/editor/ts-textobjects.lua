return function()
	require("modules.utils").load_plugin("nvim-treesitter-textobjects", {
		select = {
			lookahead = true,
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
		},
		move = {
			set_jumps = true,
		},
	})
end
