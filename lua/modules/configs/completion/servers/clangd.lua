-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/clangd.lua

local function switch_source_header_splitcmd(bufnr, splitcmd, client)
	local method_name = "textDocument/switchSourceHeader"
	---@diagnostic disable-next-line:param-type-mismatch
	if not client or not client:supports_method(method_name) then
		return vim.notify(
			("Method %s is not supported by any active server attached to buffer"):format(method_name),
			vim.log.levels.ERROR,
			{ title = "LSP Error!" }
		)
	end
	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
		end
		if not result then
			vim.notify("corresponding file cannot be determined")
			return
		end
		vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
	end, bufnr)
end

local function symbol_info(bufnr, client)
	local method_name = "textDocument/symbolInfo"
	---@diagnostic disable-next-line:param-type-mismatch
	if not client or not client:supports_method(method_name) then
		return vim.notify("Clangd client not found", vim.log.levels.ERROR)
	end
	local win = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
	---@diagnostic disable-next-line:param-type-mismatch
	client:request(method_name, params, function(err, res)
		if err or #res == 0 then
			-- Clangd always returns an error, there is no reason to parse it
			return
		end
		local container = string.format("container: %s", res[1].containerName) ---@type string
		local name = string.format("name: %s", res[1].name) ---@type string
		vim.lsp.util.open_floating_preview({ name, container }, "", {
			height = 2,
			width = math.max(string.len(name), string.len(container)),
			focusable = false,
			focus = false,
			title = "Symbol Info",
		})
	end, bufnr)
end

local function get_binary_path_list(binaries)
	local path_list = {}
	for _, binary in ipairs(binaries) do
		local path = vim.fn.exepath(binary)
		if path ~= "" then
			table.insert(path_list, path)
		end
	end
	return table.concat(path_list, ",")
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/clangd.lua
return function(defaults)
	vim.lsp.config("clangd", {
		capabilities = vim.tbl_deep_extend("keep", { offsetEncoding = { "utf-16", "utf-8" } }, defaults.capabilities),
		single_file_support = true,
		cmd = {
			"clangd",
			"-j=9",
			"--enable-config",
			-- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
			"--query-driver=" .. get_binary_path_list({ "clang++", "clang", "gcc", "g++" }),
			"--all-scopes-completion",
			"--background-index",
			"--clang-tidy",
			"--completion-parse=auto",
			"--completion-style=bundled",
			"--function-arg-placeholders",
			"--header-insertion-decorators",
			"--header-insertion=iwyu",
			"--limit-references=1000",
			"--limit-results=300",
			"--pch-storage=memory",
			"--compile-commands-dir=.",
		},
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
				switch_source_header_splitcmd(bufnr, "edit", client)
			end, { desc = "Open source/header in a new vsplit" })

			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeaderVsplit", function()
				switch_source_header_splitcmd(bufnr, "vsplit", client)
			end, { desc = "Open source/header in a new vsplit" })

			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeaderSplit", function()
				switch_source_header_splitcmd(bufnr, "split", client)
			end, { desc = "Open source/header in a new split" })

			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
				symbol_info(bufnr, client)
			end, { desc = "Show symbol info" })
		end,
	})
end
