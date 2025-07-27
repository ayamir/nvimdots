return function()
	require("modules.utils").load_plugin("nvim-ts-autotag", {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
	})
end
