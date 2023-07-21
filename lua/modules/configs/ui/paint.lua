local M = {}

M["opts"] = function()
    return {
		---type PaintHighlight[]
		highlights = {
			{
				-- filter can be a table of buffer options that should match,
				-- or a function called with buf as param that should return true.
				-- The example below will paint @something in comments with Constant
				filter = { filetype = "lua" },
				pattern = "%s*%-%-%-%s*(@%w+)",
				hl = "Constant",
			},
			{
				filter = { filetype = "python" },
				pattern = "%s*([_%w]+:)",
				hl = "Constant",
			},
		},
	}
end

M["config"] = function(_, opts)
	require("paint").setup(opts)
end

return M