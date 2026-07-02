local M = {}

M.setup = function()
	local lsp_deps = require("core.settings").lsp_deps
	-- Mason is an optional installer backend: guard its requires so a Mason-less
	-- setup still resolves servers from $PATH instead of hard-erroring here.
	local has_registry, mason_registry = pcall(require, "mason-registry")
	local has_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
	local mason_ok = has_registry and has_mlsp
	local tools = require("modules.utils.tools")

	vim.diagnostic.config({
		signs = true,
		underline = true,
		virtual_text = false,
		update_in_insert = false,
	})

	local opts = {
		capabilities = require("modules.utils").get_lsp_capabilities(),
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
			require("modules.utils").register_server(lsp_name, opts)
		elseif type(custom_handler) == "function" then
			-- Case where language server requires its own setup
			-- Be sure to call `vim.lsp.config()` within the setup function.
			-- Refer to |vim.lsp.config()| for documentation.
			-- For an example, see `clangd.lua`.
			custom_handler(opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "table" then
			require("modules.utils").register_server(
				lsp_name,
				vim.tbl_deep_extend(
					"force",
					opts,
					type(default_handler) == "table" and default_handler or {},
					custom_handler
				)
			)
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

	-- Map lspconfig server name -> Mason package name (only when Mason is present).
	-- Used to tell whether a server has a Mason package at all, and to drive
	-- installs. Build by hand if the builtin map is unavailable.
	local lspconfig_to_package = {}
	if mason_ok then
		local mappings = mason_lspconfig.get_mappings()
		lspconfig_to_package = (mappings and mappings.lspconfig_to_package) or {}
		if vim.tbl_isempty(lspconfig_to_package) then
			for _, spec in ipairs(mason_registry.get_all_package_specs()) do
				local server = vim.tbl_get(spec, "neovim", "lspconfig")
				if server then
					lspconfig_to_package[server] = spec.name
				end
			end
		end

		-- Load mason-lspconfig for the lspconfig integration only. Installs are
		-- driven explicitly below (discovery-first) so they degrade gracefully where
		-- Mason can't help (BSD/NixOS/...), instead of being gated on the installed set.
		require("modules.utils").load_plugin("mason-lspconfig", {
			ensure_installed = {},
			-- Skip auto enable because we are loading language servers lazily
			automatic_enable = false,
		})
	end

	---Resolve a server's launch binary for the $PATH probe. Prefer an explicit
	---`cmd` from the manual spec (user override, then repo default under
	---`completion/servers/`), then fall back to nvim-lspconfig's default `cmd`.
	---This way a server defined only via a local spec (with no nvim-lspconfig
	---entry) is still discoverable on $PATH.
	---@param name string
	---@return string|nil
	local function server_binary(name)
		for _, module in ipairs({ "user.configs.lsp-servers." .. name, "completion.servers." .. name }) do
			local ok, spec = pcall(require, module)
			if ok and type(spec) == "table" and type(spec.cmd) == "table" then
				return spec.cmd[1]
			end
		end
		local ok, config = pcall(function()
			return vim.lsp.config[name]
		end)
		if ok and type(config) == "table" and type(config.cmd) == "table" then
			return config.cmd[1]
		end
		return nil
	end

	-- Discovery-first resolution per desired server:
	--   1. Mason-installed OR binary already on $PATH -> configure now.
	--   2. Not available but Mason ships a package    -> install, configure next launch.
	--   3. No Mason package and not on $PATH           -> ask the user to install it.
	local collector = tools.missing_collector("LSP")

	for _, name in ipairs(lsp_deps) do
		local pkg_name = mason_ok and lspconfig_to_package[name] or nil
		local installed = pkg_name ~= nil and mason_registry.is_installed(pkg_name)
		local binary = server_binary(name)
		local on_path = binary ~= nil and vim.fn.executable(binary) == 1

		if installed or on_path then
			-- Guard the handler: a user/server spec that errors during setup would
			-- otherwise abort the whole loop (skipping the remaining servers and
			-- collector.done()). Degrade by marking just that server.
			if not pcall(mason_lsp_handler, name) then
				collector.mark(name)
			end
		elseif pkg_name ~= nil then
			local ok, pkg = pcall(mason_registry.get_package, pkg_name)
			if ok then
				collector.track(pkg, name, function()
					return pkg:is_installed() or (binary ~= nil and vim.fn.executable(binary) == 1)
				end)
			else
				-- The server maps to a Mason package the registry doesn't have
				-- (stale mapping / registry skew). The lookup that failed was for
				-- `pkg_name`, so record that (annotated with the server) rather than
				-- `name` — otherwise the warning wrongly implicates the user's
				-- lsp_deps entry when the mapping/registry is at fault.
				collector.mark_unknown(pkg_name == name and name or (pkg_name .. " (for " .. name .. ")"))
			end
		else
			collector.mark(name)
		end
	end

	collector.done()
end

return M
