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
		ensure_installed = require("core.settings").lsp_deps,
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	local opts = {
		on_attach = function()
			require("lsp_signature").on_attach({
				bind = true,
				use_lspsaga = false,
				floating_window = true,
				fix_pos = true,
				hint_enable = true,
				hi_parameter = "Search",
				handler_opts = {
					border = "rounded",
				},
			})
		end,
		capabilities = capabilities,
	}

	---A handler to setup all servers defined under `completion/servers/*.lua`
	---@param lsp_name string
	local function mason_handler(lsp_name)
		local ok, custom_handler = pcall(require, "completion.servers." .. lsp_name)
		if not ok then
			-- Default to use factory config for server(s) that doesn't include a spec
			nvim_lsp[lsp_name].setup(opts)
			return
		elseif type(custom_handler) == "function" then
			--- Case where language server requires its own setup
			--- Make sure to call require("lspconfig")[lsp_name].setup() in the function
			--- See `clangd.lua` for example.
			custom_handler(opts)
		elseif type(custom_handler) == "table" then
			nvim_lsp[lsp_name].setup(vim.tbl_deep_extend("force", opts, custom_handler))
		else
			vim.notify(
				string.format(
					"Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
					lsp_name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-lspconfig" }
			)
		end
	end

	mason_lspconfig.setup_handlers({ mason_handler })

	-- Set lsps that are not supported by `mason.nvim` but supported by `nvim-lspconfig` here.
	if vim.fn.executable("dart") then
		local _opts = require("completion.servers.dartls")
		local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
		nvim_lsp.dartls.setup(final_opts)
	end
end
