return vim.schedule_wrap(function()
	vim.api.nvim_set_option_value("indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()", {})

	require("modules.utils").load_plugin("nvim-treesitter", {})

	-- Only a parser that is not installed yet needs the toolchain. `get_installed()` is the set
	-- `install()` skips, so with every parser present nothing is probed and nothing is reported.
	local installed = require("nvim-treesitter").get_installed()
	local missing = vim.tbl_filter(function(lang)
		return not vim.list_contains(installed, lang)
	end, require("core.settings").treesitter_deps)
	if #missing == 0 then
		return
	end

	local ts = require("modules.utils.treesitter")
	if ts.can_build_parsers() then
		require("nvim-treesitter").install(missing)
	else
		ts.notify_unbuildable()
	end
end)
