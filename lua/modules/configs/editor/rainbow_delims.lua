return function()
	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = require("rainbow-delimiters").strategy["local"],
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
