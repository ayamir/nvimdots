local M = {}

local format_on_save = true

vim.cmd([[command! FormatToggle lua require'modules.completion.formatting'.toggle_format_on_save()]])

function M.enable_format_on_save(is_configure)
	local opts = { pattern = "*", timeout = 1000 }
	vim.api.nvim_create_augroup("format_on_save", {})
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = "format_on_save",
		pattern = opts.pattern,
		callback = function()
			require("modules.completion.formatting").format({ timeout_ms = opts.timeout, filter = M.format_filter })
		end,
	})
	if not is_configure then
		vim.notify("Enabled format-on-save", vim.log.levels.INFO)
	end
end

function M.disable_format_on_save()
	pcall(vim.api.nvim_del_augroup_by_name, "format_on_save")
	vim.notify("Disabled format-on-save", vim.log.levels.INFO)
end

function M.configure_format_on_save()
	if format_on_save then
		M.enable_format_on_save(true)
	else
		M.disable_format_on_save()
	end
end

function M.toggle_format_on_save()
	local status, _ = pcall(vim.api.nvim_get_autocmds, {
		group = "format_on_save",
		event = "BufWritePre",
	})
	if not status then
		M.enable_format_on_save(false)
	else
		M.disable_format_on_save()
	end
end

function M.format_filter(clients)
	return vim.tbl_filter(function(client)
		local status_ok, formatting_supported = pcall(function()
			return client.supports_method("textDocument/formatting")
		end)
		if status_ok and formatting_supported and client.name == "efm" then
			return "efm"
		elseif client.name ~= "sumneko_lua" and client.name ~= "tsserver" and client.name ~= "clangd" then
			return status_ok and formatting_supported and client.name
		end
	end, clients)
end

function M.format(opts)
	local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	local clients = vim.lsp.buf_get_clients(bufnr)

	if opts.filter then
		clients = opts.filter(clients)
	elseif opts.id then
		clients = vim.tbl_filter(function(client)
			return client.id == opts.id
		end, clients)
	elseif opts.name then
		clients = vim.tbl_filter(function(client)
			return client.name == opts.name
		end, clients)
	end

	clients = vim.tbl_filter(function(client)
		return client.supports_method("textDocument/formatting")
	end, clients)

	if #clients == 0 then
		vim.notify("[LSP] Format request failed, no matching language servers.")
	end

	local timeout_ms = opts.timeout_ms
	for _, client in pairs(clients) do
		local params = vim.lsp.util.make_formatting_params(opts.formatting_options)
		local result, err = client.request_sync("textDocument/formatting", params, timeout_ms, bufnr)
		if result and result.result then
			vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
			vim.notify(string.format("Format successfully with %s!", client.name), vim.log.levels.INFO)
		elseif err then
			vim.notify(string.format("[LSP][%s] %s", client.name, err), vim.log.levels.WARN)
		end
	end
end

return M
