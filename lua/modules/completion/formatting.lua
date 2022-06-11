local M = {}

local home = os.getenv("HOME")

local disabled_worksapce_path = home .. "/.config/nvim/format_disabled_dirs.txt"
local disabled_worksapce_file = io.open(disabled_worksapce_path, "r")
local disabled_worksapce = {}

if disabled_worksapce_file ~= nil then
	for line in disabled_worksapce_file:lines() do
		local str = line:gsub("%s+", "")
		table.insert(disabled_worksapce, str)
	end
end

local format_on_save = true

vim.api.nvim_create_user_command("FormatToggle", function()
	M.toggle_format_on_save()
end, {})

function M.enable_format_on_save(is_configured)
	local opts = { pattern = "*", timeout = 1000 }
	vim.api.nvim_create_augroup("format_on_save", {})
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = "format_on_save",
		pattern = opts.pattern,
		callback = function()
			require("modules.completion.formatting").format({ timeout_ms = opts.timeout, filter = M.format_filter })
		end,
	})
	if not is_configured then
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
	local cwd = vim.fn.getcwd()
	for i = 1, #disabled_worksapce do
		if cwd.find(cwd, disabled_worksapce[i]) ~= nil then
			return
		end
	end

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
