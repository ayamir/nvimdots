return function()
	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = function()
				local ok, is_large_file = pcall(vim.api.nvim_buf_get_var, vim.fn.bufnr(), "bigfile_disable_treesitter")
				if ok and is_large_file then
					return nil
				end
				return require("rainbow-delimiters").strategy["global"]
			end,
		},
		query = {
			[""] = "rainbow-delimiters",
			latex = "rainbow-blocks",
			javascript = "rainbow-delimiters-ract",
		},
		highlight = {
			"RainbowDelimiterRed",
			"RainbowDelimiterOrange",
			"RainbowDelimiterYellow",
			"RainbowDelimiterGreen",
			"RainbowDelimiterBlue",
			"RainbowDelimiterCyan",
			"RainbowDelimiterViolet",
		},
	}
end
