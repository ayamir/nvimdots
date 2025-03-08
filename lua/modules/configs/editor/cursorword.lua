return function()
	require("mini.cursorword").setup({
		-- Delay (in ms) between when cursor moved and when highlighting appeared
		delay = 200,
	})
	require("modules.utils").gen_cursorword_hl()
end
