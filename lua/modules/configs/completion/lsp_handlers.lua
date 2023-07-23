local M = {}

local icons = {
	cmp = require("modules.utils.icons").get("cmp", true),
	diagnostics = require("modules.utils.icons").get("diagnostics", true),
	kind = require("modules.utils.icons").get("kind", true),
	type = require("modules.utils.icons").get("type", true),
	ui = require("modules.utils.icons").get("ui", true),
}
local diagnostics_virtual_text = require("core.settings").diagnostics_virtual_text
local diagnostics_level = require("core.settings").diagnostics_level

M.set_sidebar_icons = function()
	-- Set icons for sidebar.
	local diagnostic_icons = {
		Error = icons.diagnostics.Error,
		Warn = icons.diagnostics.Warning,
		Info = icons.diagnostics.Information,
		Hint = icons.diagnostics.Hint,
	}
	for type, icon in pairs(diagnostic_icons) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl })
	end
end

M.set_lsp_config = function()
	local lsp = vim.lsp

	local popup_opts = { border = "rounded", max_width = 80, silent = false, focusable = true }

	lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, popup_opts)
	lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.hover, popup_opts)
	local config = {
		virtual_text = diagnostics_virtual_text and {
			severity_limit = diagnostics_level,
		} or false,
		signs = true,
		underline = true,
		severity_sort = true,
		update_in_insert = false, -- update diagnostics insert mode
		float = {
			focusable = false,
			border = "rounded",
			source = "always",
			header = "🙀Diagnostics:",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)
end

M.make_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- TODO: why set dynamicRegistration to true as default?
	capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
	capabilities.textDocument.completion.completionItem = {
		documentationFormat = { "markdown", "plaintext" },
	}
	-- nvim-cmp supports additional completion capabilities
	vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
	return capabilities
end

M.on_attach = function(client, bufnr)
	-- general
	client.config.flags.allow_incremental_sync = true

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- keybindings
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "<tab>", ":lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>gq", "<cmd>lua vim.diagnostic.setqflist()<CR>", opts)
	buf_set_keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>', opts)
	buf_set_keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>', opts)
	if client.name == "rust_analyzer" then
		vim.keymap.set("n", "<Leader>gh", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
	end

	-- autocmd
	local lsplinediagnosticsgroup = vim.api.nvim_create_augroup("lsplinediagnostics", { clear = true })
	vim.api.nvim_create_autocmd("cursorhold", {
		group = lsplinediagnosticsgroup,
		pattern = "*",
		callback = function()
			-- if change scope to "line", then diagnostic will toggle the whole line
			vim.diagnostic.open_float(0, {
				scope = "cursor",
				focusable = false,
			})
		end,
	})

	if client.server_capabilities.codelensprovider then
		local lspcodelensgroup = vim.api.nvim_create_augroup("lspcodelens", { clear = true })
		vim.api.nvim_create_autocmd({ "cursorhold", "bufenter", "insertleave" }, {
			group = lspcodelensgroup,
			callback = function()
				vim.lsp.codelens.refresh()
				vim.notify("codelens refreshed")
			end,
			buffer = 0,
		})
	end

	if client.server_capabilities.documentHighlightProvider then
		local highlight_name = vim.fn.printf("lsp_document_highlight_%d", bufnr)
		vim.api.nvim_create_augroup(highlight_name, {})
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = highlight_name,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.document_highlight()
			end,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = highlight_name,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.clear_references()
			end,
		})
	end

	if client.name == "pyright" then
		client.server_capabilities.hoverProvider = false
		client.server_capabilities.signatureHelpProvider = false
	elseif client.name == "pylyzer" then
		client.server_capabilities.hoverProvider = false
	elseif client.name == "jedi_language_server" then
		-- client.server_capabilities.documentSymbolProvider = false
		client.server_capabilities.codeActionProvider = false
		client.server_capabilities.completionProvider = false
		client.server_capabilities.referencesProvider = false
		client.server_capabilities.definitionProvider = false
	elseif client.name == "sourcery" then
		client.server_capabilities.hoverProvider = false
	end
	-- client.server_capabilities.semanticTokensProvider = nil
end

return M
