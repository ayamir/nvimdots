return function()
	local icons = { ui = require("modules.utils.icons").get("ui", true) }

	require("modules.utils").load_plugin("fzf-lua", {
		{ "telescope" },
		defaults = {
			prompt = icons.ui.Telescope .. " ",
		},
	})
end
