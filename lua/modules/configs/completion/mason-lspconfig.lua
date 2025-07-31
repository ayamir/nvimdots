local M = {}

M.setup = function()
	local diagnostics_virtual_lines = require("core.settings").diagnostics_virtual_lines
	local diagnostics_level = require("core.settings").diagnostics_level
	local lsp_deps = require("core.settings").lsp_deps
	local use_python_experimental_lsp = require("core.settings").use_python_experimental_lsp
	local python_experimental_lsp_deps = require("core.settings").python_experimental_lsp_deps

	require("lspconfig.ui.windows").default_options.border = "rounded"
	require("modules.utils").load_plugin("mason-lspconfig", {
		ensure_installed = lsp_deps,
	})

	vim.diagnostic.config({
		signs = true,
		underline = false,
		virtual_text = false,
		virtual_lines = diagnostics_virtual_lines and {
			severity = {
				min = vim.diagnostic.severity[diagnostics_level],
			},
		} or false,
		-- set update_in_insert to false because it was enabled by lspsaga
		update_in_insert = false,
	})

	local opts = {
		capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		),
	}
	---A handler to setup all servers defined under `completion/servers/*.lua`
	---@param lsp_name string
	local function mason_lsp_handler(lsp_name)
		-- rust_analyzer is configured using mrcjkb/rustaceanvim
		-- warn users if they have set it up manually
		if lsp_name == "rust_analyzer" then
			local config_exist = pcall(require, "completion.servers." .. lsp_name)
			if config_exist then
				vim.notify(
					[[
`rust_analyzer` is configured independently via `mrcjkb/rustaceanvim`. To get rid of this warning,
please REMOVE your LSP configuration (rust_analyzer.lua) from the `servers` directory and configure
`rust_analyzer` using the appropriate init options provided by `rustaceanvim` instead.]],
					vim.log.levels.WARN,
					{ title = "nvim-lspconfig" }
				)
			end
			return
		end

		local ok, custom_handler = pcall(require, "user.configs.lsp-servers." .. lsp_name)
		local default_ok, default_handler = pcall(require, "completion.servers." .. lsp_name)
		-- Use preset if there is no user definition
		if not ok then
			ok, custom_handler = default_ok, default_handler
		end

		if not ok then
			-- Default to use factory config for server(s) that doesn't include a spec
			vim.lsp.config(lsp_name, opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "function" then
			--- Case where language server requires its own setup
			--- Make sure to call require("lspconfig")[lsp_name].setup() in the function
			--- See `clangd.lua` for example.
			custom_handler(opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "table" then
			vim.lsp.config(
				lsp_name,
				vim.tbl_deep_extend(
					"force",
					opts,
					type(default_handler) == "table" and default_handler or {},
					custom_handler
				)
			)
			vim.lsp.enable(lsp_name)
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

	--- the LSP for python should be set up differently depend on the value of `use_python_experimental_lsp`.
	--- If both `use_python_experimental_lsp` and `python_experimental_lsp_deps` are set,
	--- we'll use the experimental LSP with the specified dependencies.
	--- Otherwise, default `pylsp` will be used.
	if use_python_experimental_lsp then
		if not python_experimental_lsp_deps or #python_experimental_lsp_deps == 0 then
			vim.notify(
				[[
If you want to use the experimental Python LSP,
please set `python_experimental_lsp_deps` in your settings.
Fallback to default `pylsp` now.]],
				vim.log.levels.WARN,
				{ title = "nvim-lspconfig" }
			)
		else
			mason_lsp_handler("pylsp")
		end
	else
		for _, exp_py_lsp in ipairs(python_experimental_lsp_deps) do
			mason_lsp_handler(exp_py_lsp)
		end
		mason_lsp_handler("ruff") -- for linting and formatting as the exp LSPs do not support it
	end

	for _, lsp in ipairs(lsp_deps) do
		mason_lsp_handler(lsp)
	end
end

return M
