local function switch_source_header_splitcmd(bufnr, splitcmd)
	bufnr = require("lspconfig").util.validate_bufnr(bufnr)
	local clangd_client = require("lspconfig").util.get_active_client_by_name(bufnr, "clangd")
	local params = { uri = vim.uri_from_bufnr(bufnr) }
	if clangd_client then
		clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				vim.notify("Corresponding file can’t be determined", vim.log.levels.ERROR, { title = "LSP Error!" })
				return
			end
			vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
		end)
	else
		vim.notify(
			"Method textDocument/switchSourceHeader is not supported by any active server on this buffer",
			vim.log.levels.ERROR,
			{ title = "LSP Error!" }
		)
	end
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/clangd.lua
return {
	single_file_support = true,
	cmd = {
		"clangd",
		"--background-index",
		"--pch-storage=memory",
		-- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
		"--query-driver=/usr/bin/clang++,/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
		"--clang-tidy",
		"--all-scopes-completion",
		"--completion-style=detailed",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
	},
	commands = {
		ClangdSwitchSourceHeader = {
			function()
				switch_source_header_splitcmd(0, "edit")
			end,
			description = "Open source/header in current buffer",
		},
		ClangdSwitchSourceHeaderVSplit = {
			function()
				switch_source_header_splitcmd(0, "vsplit")
			end,
			description = "Open source/header in a new vsplit",
		},
		ClangdSwitchSourceHeaderSplit = {
			function()
				switch_source_header_splitcmd(0, "split")
			end,
			description = "Open source/header in a new split",
		},
	},
}
