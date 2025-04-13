return function()
	require("modules.utils").load_plugin("garbage-day", {
		excluded_lsp_clients = { "null-ls" },
		notifications = true,
	})
end
