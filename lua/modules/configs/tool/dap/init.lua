return function()
	local dap = require("dap")
	local dapui = require("dapui")
	-- Mason is an optional installer backend: guard its require so a Mason-less
	-- setup still configures adapters that resolve their own binary (client
	-- configs / $PATH) instead of hard-erroring here.
	local has_mason_dap, mason_dap = pcall(require, "mason-nvim-dap")

	local icons = { dap = require("modules.utils.icons").get("dap") }
	local colors = require("modules.utils").get_palette()
	local mappings = require("tool.dap.dap-keymap")

	-- Initialize debug hooks
	_G._debugging = false
	local function debug_init_cb()
		_G._debugging = true
		mappings.load_extras()
		dapui.open({ reset = true })
	end
	local function debug_terminate_cb()
		if _debugging then
			_G._debugging = false
		end
	end
	local function debug_disconnect_cb()
		if _debugging then
			_G._debugging = false
			dapui.close()
		end
	end
	dap.listeners.after.event_initialized["dapui_config"] = debug_init_cb
	dap.listeners.before.event_terminated["dapui_config"] = debug_terminate_cb
	dap.listeners.before.event_exited["dapui_config"] = debug_terminate_cb
	dap.listeners.before.disconnect["dapui_config"] = debug_disconnect_cb

	-- We need to override nvim-dap's default highlight groups, AFTER requiring nvim-dap for catppuccin.
	vim.api.nvim_set_hl(0, "DapStopped", { fg = colors.green })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = icons.dap.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = icons.dap.BreakpointCondition, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapStopped", { text = icons.dap.Stopped, texthl = "DapStopped", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = icons.dap.BreakpointRejected, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapLogPoint", { text = icons.dap.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })

	---A handler to setup all clients defined under `tool/dap/clients/*.lua`
	---@param config table
	local function mason_dap_handler(config)
		local dap_name = config.name
		local ok, custom_handler = pcall(require, "user.configs.dap-clients." .. dap_name)
		if not ok then
			-- Use preset if there is no user definition
			ok, custom_handler = pcall(require, "tool.dap.clients." .. dap_name)
		end
		if not ok then
			-- Default to Mason's factory config for clients without a spec, only when
			-- mason-nvim-dap is available.
			if has_mason_dap then
				mason_dap.default_setup(config)
			end
			return
		elseif type(custom_handler) == "function" then
			-- Case where the protocol requires its own setup
			-- Make sure to set
			-- * dap.adapters.<dap_name> = { your config }
			-- * dap.configurations.<lang> = { your config }
			-- See `codelldb.lua` for a concrete example.
			custom_handler(config)
		else
			vim.notify(
				string.format(
					"Failed to setup [%s].\n\nClient definition under `tool/dap/clients` must return\na fun(opts) (got '%s' instead)",
					config.name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-dap" }
			)
		end
	end

	local settings = require("core.settings")
	local tools = require("modules.utils.tools")

	-- Mason-driven bits (source/adapter mappings + install) are only available when
	-- Mason is. Without it we still configure adapters that resolve their own binary
	-- (client configs / $PATH). Either way we drive setup discovery-first rather than
	-- letting mason-nvim-dap gate configuration on its installed set.
	local has_registry, registry = pcall(require, "mason-registry")
	local mason_ok = has_mason_dap and has_registry
	local source_map = { nvim_dap_to_package = {} }
	local adapters_map, configs_map, filetypes_map = {}, {}, {}
	if mason_ok then
		require("modules.utils").load_plugin("mason-nvim-dap", {
			ensure_installed = {},
			automatic_installation = false,
		})
		source_map = require("mason-nvim-dap.mappings.source")
		adapters_map = require("mason-nvim-dap.mappings.adapters")
		configs_map = require("mason-nvim-dap.mappings.configurations")
		filetypes_map = require("mason-nvim-dap.mappings.filetypes")
	end

	---Does an explicit client config exist for this adapter (system-resolved)?
	---@param name string
	---@return boolean
	local function has_client_config(name)
		for _, module in ipairs({ "user.configs.dap-clients." .. name, "tool.dap.clients." .. name }) do
			if pcall(require, module) then
				return true
			end
		end
		return false
	end

	---Configure an adapter via the shared handler (client config or default_setup).
	---@param name string
	local function configure_adapter(name)
		mason_dap_handler({
			name = name,
			adapters = adapters_map[name],
			configurations = configs_map[name],
			filetypes = filetypes_map[name],
		})
	end

	---Best-effort launch command for a configured adapter, for a post-config
	---sanity check. Only table adapters expose a static command (executable-type
	---at `.command`, server-type at `.executable.command`); function adapters
	---resolve lazily at debug time, so they return nil (not checkable here).
	---@param adapter any @A `dap.adapters[...]` entry.
	---@return string|nil
	local function adapter_command(adapter)
		if type(adapter) ~= "table" then
			return nil
		end
		if type(adapter.executable) == "table" then
			return adapter.executable.command
		end
		return adapter.command
	end

	-- Discovery-first resolution per desired adapter:
	--   * Mason ships a package but it isn't available yet -> install (next launch).
	--   * Available now (Mason-installed / on $PATH) or has a client config -> configure.
	--   * Neither -> ask the user to install it.
	-- nvim-dap has no uniform command registry like nvim-lspconfig, so $PATH
	-- detection leans on the Mason package's declared binaries; client configs
	-- without a Mason package resolve their own binary via `vim.fn.exepath`.
	local collector = tools.missing_collector("DAP")

	for _, name in ipairs(settings.dap_deps) do
		local pkg_name = source_map.nvim_dap_to_package[name]
		local pkg
		if pkg_name then
			local ok, resolved = pcall(registry.get_package, pkg_name)
			pkg = ok and resolved or nil
		end

		local binaries = pkg ~= nil and tools.package_binaries(pkg, pkg_name) or nil
		local installed = pkg ~= nil and pkg:is_installed()
		local on_path = binaries ~= nil and tools.any_executable(binaries)
		local available = installed or on_path

		-- Install via Mason when it ships a package that isn't available yet. The
		-- install runs in the background and only updates the missing-tool warning
		-- on completion — it does not configure the adapter. An adapter without a
		-- client config is therefore configured on a later launch (once its binary
		-- is available); client-config adapters are configured immediately below.
		if pkg ~= nil and not available then
			collector.track(pkg, name, function()
				return pkg:is_installed() or tools.any_executable(binaries)
			end)
		end

		-- Configure now whenever we can: an explicit client config is the adapter's
		-- own discovery-first resolver (Mason venv / $PATH / system), and an
		-- available Mason adapter uses the default handler. This no longer waits on
		-- the Mason install, so a client config that resolves its own binary (e.g.
		-- python via system debugpy) works this session. Guarded so one failing
		-- setup can't abort the rest.
		if available or has_client_config(name) then
			if not pcall(configure_adapter, name) then
				collector.mark(name)
			elseif pkg == nil then
				-- Configured via a client config on a Mason-less setup (no install to
				-- fall back on). A table adapter that resolves its command via $PATH
				-- (e.g. codelldb through vim.fn.exepath) can silently end up with an
				-- empty/unresolved command, giving neither a working adapter nor a
				-- warning. Best-effort: if the adapter under this name has a static
				-- command that isn't on $PATH, surface it as missing.
				local cmd = adapter_command(dap.adapters[name])
				if cmd ~= nil and (cmd == "" or vim.fn.executable(cmd) == 0) then
					collector.mark(name)
				end
			end
		elseif pkg == nil then
			-- No Mason package and no client config: nothing can set it up.
			collector.mark(name)
		end
	end

	collector.done()
end
