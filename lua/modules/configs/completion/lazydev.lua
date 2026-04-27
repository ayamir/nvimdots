return function()
	require("modules.utils").load_plugin("lazydev", {
		library = {
			"lazy.nvim",
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	})
end
