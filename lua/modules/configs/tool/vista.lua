return function()
    require("modules.utils").gen_vistakind_hl()
	require("vista-nvim").setup({
		theme = "type",
		-- TODO: fix width, wirter.lua clean_path
		width = 28,
	})
end
