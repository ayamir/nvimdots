return function()
	require("modules.utils").load_plugin("local-highlight", {
		hlgroup = "IlluminatedWordText",
		insert_mode = false,
	})
end
