return function()
	local nvim_lsp = require("lspconfig")
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")

	require("lspconfig.ui.windows").default_options.border = "single"

	local icons = {
		ui = require("modules.utils.icons").get("ui", true),
		misc = require("modules.utils.icons").get("misc", true),
	}

	mason.setup({
		ui = {
			border = "rounded",
			icons = {
				package_pending = icons.ui.Modified_alt,
				package_installed = icons.ui.Check,
				package_uninstalled = icons.misc.Ghost,
			},
			keymaps = {
				toggle_server_expand = "<CR>",
				install_server = "i",
				update_server = "u",
				check_server_version = "c",
				update_all_servers = "U",
				check_outdated_servers = "C",
				uninstall_server = "X",
				cancel_installation = "<C-c>",
			},
		},
	})
	mason_lspconfig.setup({
		-- NOTE: use the lsp names in nvim-lspconfig
		-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
		ensure_installed = require("core.settings").lsp,
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	---@param use_server_formatting_provider boolean whether to use the server's formatting provider
	--- This is useful when using in conjunction with null-ls
	local on_attach_factory = function(use_server_formatting_provider)
		return function(client, _)
			if not use_server_formatting_provider then
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end
			local has_lsp_signature, lsp_signature = pcall(require, "lsp_signature")
			if has_lsp_signature then
				lsp_signature.on_attach({
					bind = true,
					use_lspsaga = false,
					floating_window = true,
					fix_pos = true,
					hint_enable = true,
					hi_parameter = "Search",
					handler_opts = { border = "rounded" },
				})
			end
		end
	end

	local opts = {
		on_attach = on_attach_factory(true),
		capabilities = capabilities,
	}

	--- Map a function over a table
	---@param tbl table<string, any>
	---@param func fun(v: any): any
	---@return table<string, any> a new table
	local function map(tbl, func)
		local newtbl = {}
		for i, v in pairs(tbl) do
			newtbl[i] = func(v)
		end
		return newtbl
	end

	local function joinpath(...)
		return table.concat(vim.tbl_flatten({ ... }), require("core.global").is_windows and "\\" or "/")
	end

	--- A small mason handler to setup for all servers function defined under completion/servers/*.lua
	---@overload fun(lsp_name: string, enable_inlay_hints?: boolean): fun():nil
	---@overload fun(lsp_name: string): fun():nil
	local function mason_handler(lsp_name, use_server_formatting_provider)
		use_server_formatting_provider = use_server_formatting_provider or false
		opts.on_attach = on_attach_factory(use_server_formatting_provider)

		return function()
			local function available_config(path)
				return map(vim.split(vim.fn.glob(path .. "/*.lua"), "\n"), function(_)
					return _:sub(#path + 2, -5)
				end)
			end

			if
				not vim.tbl_contains(
					available_config(
						joinpath(require("core.global").vim_path, "lua", "modules", "configs", "completion", "servers")
					),
					lsp_name
				)
			then
				--- NOTE: default to nvim-lspconfig for servers that doesn't include a configuration setup
				nvim_lsp[lsp_name].setup(opts)
				return
			end

			local lspconfig = require("completion.servers")[lsp_name]
			if type(lspconfig) == "function" then
				--- NOTE: case where language server requires its own setup
				--- Make sure to call require("lspconfig")[lsp_name].setup() in the function
				--- See clangd.lua for example.
				lspconfig(opts)
			elseif type(lspconfig) == "table" then
				nvim_lsp[lsp_name].setup(vim.tbl_deep_extend("force", opts, lspconfig))
			else
				error(
					string.format(
						"Failed to setup '%s'. Server definition under completion/servers must return either a fun(opts) or a table (got type %s instead).",
						lsp_name,
						type(lspconfig)
					),
					vim.log.levels.ERROR
				)
			end
		end
	end

	mason_lspconfig.setup_handlers({
		function(server)
			ok, _ = pcall(mason_handler(server))
			if not ok then
				error(string.format("Failed to setup lspconfig for %s", server), vim.log.levels.ERROR)
			end
		end,
	})
end
