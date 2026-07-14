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
		-- These are mason-nvim-dap's private internals, not a public API: guard each
		-- require so a version that renames/removes one degrades to client-config /
		-- $PATH resolution instead of aborting the entire dap config.
		local function map_or_empty(mod, default)
			local ok, m = pcall(require, mod)
			return (ok and type(m) == "table") and m or default
		end
		source_map = map_or_empty("mason-nvim-dap.mappings.source", { nvim_dap_to_package = {} })
		adapters_map = map_or_empty("mason-nvim-dap.mappings.adapters", {})
		configs_map = map_or_empty("mason-nvim-dap.mappings.configurations", {})
		filetypes_map = map_or_empty("mason-nvim-dap.mappings.filetypes", {})
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
	---Each client config self-validates its binary and `error()`s when it can't be
	---resolved, which the shared resolver surfaces as missing (with the message) —
	---so there is no separate post-config sanity check here.
	---@param name string
	local function configure_adapter(name)
		mason_dap_handler({
			name = name,
			adapters = adapters_map[name],
			configurations = configs_map[name],
			filetypes = filetypes_map[name],
		})
	end

	-- Discovery-first resolution, shared with LSP and null-ls:
	--   * Available now (Mason-installed / on $PATH) or backed by a client config
	--     -> configure now (the client config resolves its own binary and errors
	--     out if absent, surfaced via the aggregated warning).
	--   * Mason ships a package but it isn't available yet -> install, then
	--     configure on completion (never configured with an unresolved binary).
	--   * Neither -> ask the user to install it.
	-- nvim-dap has no uniform command registry like nvim-lspconfig, so $PATH
	-- detection leans on the Mason package's declared binaries; client configs
	-- without a Mason package resolve their own binary.
	tools.resolve({
		title = "DAP",
		deps = settings.dap_deps,
		registry = mason_ok and registry or nil,
		package_of = function(name)
			return source_map.nvim_dap_to_package[name]
		end,
		binaries_of = function(name, pkg)
			return pkg ~= nil and tools.package_binaries(pkg, source_map.nvim_dap_to_package[name] or name) or {}
		end,
		has_local_config = has_client_config,
		configure = configure_adapter,
	})
end
