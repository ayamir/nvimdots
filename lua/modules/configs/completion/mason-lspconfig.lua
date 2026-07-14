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

	if mason_ok then
		-- Load mason-lspconfig for the lspconfig integration only. Installs are
		-- driven by the shared resolver (discovery-first) so they degrade gracefully
		-- where Mason can't help (BSD/NixOS/...), instead of being gated on the
		-- installed set.
		require("modules.utils").load_plugin("mason-lspconfig", {
			ensure_installed = {},
			-- Skip auto enable because we are loading language servers lazily
			automatic_enable = false,
		})
	end

	-- lspconfig server name -> Mason package name. Resolved lazily on first use so
	-- it is read *after* the resolver's registry refresh, when `get_mappings()`
	-- returns a fully populated map (fresh-bootstrap fix). nil when Mason absent.
	local lspconfig_to_package = nil
	local function package_of(name)
		if not mason_ok then
			return nil
		end
		if lspconfig_to_package == nil then
			local mappings = mason_lspconfig.get_mappings()
			lspconfig_to_package = (mappings and mappings.lspconfig_to_package) or {}
		end
		return lspconfig_to_package[name]
	end

	---Resolve a server's launch binary for the $PATH probe. Prefer an explicit
	---`cmd` from the manual spec (user override, then repo default under
	---`completion/servers/`), then fall back to nvim-lspconfig's default `cmd`.
	---Returns nil when the spec only exposes a function `cmd` (or no `cmd`): the
	---binary can't be probed statically, so resolution falls through to the
	---`has_local_config` path, which configures the server and lets it resolve its
	---own command, rather than wrongly flagging it missing.
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

	---Should a manual spec be treated as a resolution fallback (configure now even
	---though the $PATH probe found nothing)? Only when the launch binary can't be
	---probed statically — i.e. `server_binary` returned nil (a function/absent `cmd`
	---that resolves itself at launch). When the binary *is* known (e.g. shuck's
	---`cmd = { "shuck" }`), the $PATH check already decides availability; configuring
	---anyway would silently enable a server whose binary is missing instead of
	---surfacing it in the aggregated warning.
	---@param name string
	---@return boolean
	local function has_local_config(name)
		if server_binary(name) ~= nil then
			return false
		end
		for _, module in ipairs({ "user.configs.lsp-servers." .. name, "completion.servers." .. name }) do
			if pcall(require, module) then
				return true
			end
		end
		return false
	end

	tools.resolve({
		title = "LSP",
		deps = lsp_deps,
		registry = mason_ok and mason_registry or nil,
		package_of = package_of,
		binaries_of = function(name)
			local binary = server_binary(name)
			return binary and { binary } or {}
		end,
		has_local_config = has_local_config,
		configure = mason_lsp_handler,
	})
end

return M
