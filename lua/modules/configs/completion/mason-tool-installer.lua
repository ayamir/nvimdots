return function()
	require("mason-tool-installer").setup({
		-- a list of all tools you want to ensure are installed upon
		-- start; they should be the names Mason uses for each tool
		ensure_installed = {
			-- you can turn off/on auto_update per tool
			-- "editorconfig-checker",

			-- formatter
			"black",
			"clang-format",
			"eslint_d",
			"markdownlint",
			"prettierd",
			"rustfmt",
			"shfmt",
			"stylua",

			-- diagnostics
			"shellcheck",
		},

		-- if set to true this will check each tool for updates. If updates
		-- are available the tool will be updated.
		-- Default: false
		auto_update = false,

		-- automatically install / update on startup. If set to false nothing
		-- will happen on startup. You can use `:MasonToolsUpdate` to install
		-- tools and check for updates.
		-- Default: true
		run_on_start = true,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "MasonToolsUpdateCompleted",
		callback = function()
			vim.schedule(function()
				print("mason-tool-installer has finished")
				vim.notify("mason-tool-installer has finished!", vim.log.levels.INFO, { title = "MasonToolsInstaller" })
			end)
		end,
	})
end
