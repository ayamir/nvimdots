return function()
	---@param threshold number @Use global strategy if nr of lines exceeds this value
	local function init_strategy(threshold)
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
			return vim.fn.line("$") > threshold and require("rainbow-delimiters").strategy["global"]
				or require("rainbow-delimiters").strategy["local"]
		end
	end

	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = init_strategy(500),
			c = init_strategy(200),
			cpp = init_strategy(200),
			lua = init_strategy(500),
			vimdoc = init_strategy(300),
			vim = init_strategy(300),
		},
		query = {
			[""] = "rainbow-delimiters",
			latex = "rainbow-blocks",
			javascript = "rainbow-delimiters-react",
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
