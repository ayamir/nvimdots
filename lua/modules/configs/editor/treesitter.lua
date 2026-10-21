return vim.schedule_wrap(function()
	vim.api.nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", {})

	require("modules.utils").load_plugin("nvim-treesitter", {})

	local ts = require("modules.utils.treesitter")
	if ts.can_build_parsers() then
		require("nvim-treesitter").install(require("core.settings").treesitter_deps)
	else
		ts.notify_unbuildable()
	end
end)
