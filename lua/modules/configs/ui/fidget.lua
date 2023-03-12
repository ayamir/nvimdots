return function()
	require("fidget").setup({
		window = { blend = 0 },
		sources = {
			["null-ls"] = { ignore = true },
		},
	})
end
