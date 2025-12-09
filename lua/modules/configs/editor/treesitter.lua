return vim.schedule_wrap(function()
	vim.api.nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", {})

	require("modules.utils").load_plugin("nvim-treesitter", {})

	require("nvim-treesitter").install(require("core.settings").treesitter_deps)
end)
