return function()
	local function init_strategy(check_lines)
		return function()
			local errors = 200
			vim.treesitter.get_parser():for_each_tree(function(lt)
				if lt:root():has_error() and errors >= 0 then
					errors = errors - 1
				end
			end)
			if errors < 0 then
				return nil
			end
			return (check_lines and vim.fn.line("$") > 350) and require("rainbow-delimiters").strategy["global"]
				or require("rainbow-delimiters").strategy["local"]
		end
	end

	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = init_strategy(false),
			c = init_strategy(true),
			cpp = init_strategy(true),
			vimdoc = init_strategy(true),
			vim = init_strategy(true),
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
