return function()
	require("modules.utils").load_plugin("mini.cursorword", {
		-- Delay (in ms) between when cursor moved and when highlighting appeared
		delay = 200,
	})
end
