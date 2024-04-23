return {
	options = {
		diagnostics = nil,
		numbers = function(opts)
			return string.format("%s.", opts.ordinal)
		end,
	},
}
