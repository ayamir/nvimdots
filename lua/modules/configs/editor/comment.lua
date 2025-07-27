return function()
	require("modules.utils").load_plugin("Comment", {
		ignore = "^$",
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end
