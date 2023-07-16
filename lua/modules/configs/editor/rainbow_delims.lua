return function()
	local function init_strategy()
		local errors = 200
		vim.treesitter.get_parser():for_each_tree(function(lt)
			if lt:root():has_error() and errors >= 0 then
				errors = errors - 1
			end
		end)
		if errors < 0 then
			return nil
		end
		return require("rainbow-delimiters").strategy["local"]
	end

	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = init_strategy,
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
