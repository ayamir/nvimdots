local M = {}

M.setup = function()
	local lsp_deps = require("core.settings").lsp_deps
	-- dartls ships inside the Dart SDK (no Mason package), so its availability is
	-- keyed on the `dart` executable: auto-add it when `dart` is on $PATH — same
	-- auto-enable behavior as the historical inline check in `lsp.lua`, but routed
	-- through the shared resolver like every other server. Copy-on-inject keeps
	-- the shared settings table unmutated; an explicit "dartls" entry in
	-- `lsp_deps` still works (and forces the missing-tool warning when `dart`
	-- is absent).
	if vim.fn.executable("dart") == 1 and not vim.tbl_contains(lsp_deps, "dartls") then
		lsp_deps = vim.list_extend({ "dartls" }, lsp_deps)
	end
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
		-- rust_analyzer is configured using mrcjkb/rustaceanvim; never configure it
		-- here (the stray-config warning is issued unconditionally in setup below,
		-- since this handler only runs for `lsp_deps` entries).
		if lsp_name == "rust_analyzer" then
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

	-- rust_analyzer is configured independently via mrcjkb/rustaceanvim; a stray
	-- manual spec is a misconfiguration regardless of whether rust_analyzer is in
	-- `lsp_deps` (the resolver below only visits deps entries, so the old
	-- inside-the-handler warning would never fire for the common case).
	for _, module in ipairs({ "user.configs.lsp-servers.rust_analyzer", "completion.servers.rust_analyzer" }) do
		-- Presence check WITHOUT executing the module: a stray spec should be
		-- reported even when it errors at load (especially then), and requiring it
		-- just to probe existence would run its module-level code for the side
		-- effects. Neovim keeps package.path in sync with 'runtimepath' (see
		-- :h lua-package-path), so searchpath sees the same modules require would.
		if package.searchpath(module, package.path) then
			vim.notify(
				[[
`rust_analyzer` is configured independently via `mrcjkb/rustaceanvim`. To get rid of this warning,
please REMOVE your LSP configuration (rust_analyzer.lua) from the `servers` directory and configure
`rust_analyzer` using the appropriate init options provided by `rustaceanvim` instead.]],
				vim.log.levels.WARN,
				{ title = "nvim-lspconfig" }
			)
			break
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

	---Probe a server's manual spec once and cache the result, so the resolver's
	---predicates (binaries_of / has_local_config) don't re-require the same modules
	---for every call (mirrors mason-null-ls.lua's info() cache). `binary` prefers an
	---explicit `cmd` from the manual spec (user override, then repo default under
	---`completion/servers/`), then nvim-lspconfig's default `cmd`; it stays nil when
	---only a function `cmd` (or none) exists — such a spec resolves its own command
	---at launch, so it becomes the `has_local_config` fallback instead.
	local server_info_cache = {}
	---@param name string
	---@return { has_module: boolean, binary: string|nil }
	local function server_info(name)
		local cached = server_info_cache[name]
		if cached then
			return cached
		end
		local info = { has_module = false, binary = nil }
		for _, module in ipairs({ "user.configs.lsp-servers." .. name, "completion.servers." .. name }) do
			local ok, spec = pcall(require, module)
			if ok then
				info.has_module = true
				if info.binary == nil and type(spec) == "table" and type(spec.cmd) == "table" then
					info.binary = spec.cmd[1]
				end
			end
		end
		if info.binary == nil then
			local ok, config = pcall(function()
				return vim.lsp.config[name]
			end)
			if ok and type(config) == "table" and type(config.cmd) == "table" then
				info.binary = config.cmd[1]
			end
		end
		server_info_cache[name] = info
		return info
	end

	---Should a manual spec be treated as a resolution fallback (configure now even
	---though the $PATH probe found nothing)? Only when the launch binary can't be
	---probed statically — a function/absent `cmd` that resolves itself at launch.
	---When the binary *is* known (e.g. shuck's `cmd = { "shuck" }`), the $PATH check
	---already decides availability; configuring anyway would silently enable a
	---server whose binary is missing instead of surfacing it in the warning.
	---@param name string
	---@return boolean
	local function has_local_config(name)
		local info = server_info(name)
		return info.binary == nil and info.has_module
	end

	---Mirror the none-ls `PATH = "skip"` handling (see mason-null-ls.lua): a
	---Mason-installed server counts as available (`is_installed()`) even when its
	---binary is only resolvable inside Mason's bin dir, so the handler above would
	---register a bare `cmd[1]` that lspconfig later fails to spawn. After the
	---handler runs, rewrite the *registered* config's `cmd[1]` to the absolute
	---path find_executable resolves (it probes Mason's bin dir after $PATH).
	---Checked against the registered cmd — not the cached spec probe — so user
	---overrides and lspconfig defaults are covered alike; function `cmd`s (which
	---resolve themselves at launch) and already-spawnable names are left alone.
	---@param name string
	local function rewrite_cmd_off_path(name)
		local ok, config = pcall(function()
			return vim.lsp.config[name]
		end)
		if not ok or type(config) ~= "table" or type(config.cmd) ~= "table" then
			return
		end
		local binary = config.cmd[1]
		if type(binary) ~= "string" or binary == "" or vim.fn.executable(binary) == 1 then
			return
		end
		local path = tools.find_executable(binary)
		if not path then
			return
		end
		local cmd = vim.deepcopy(config.cmd)
		cmd[1] = path
		-- Lists are replaced wholesale (not index-merged) by the deep-extend in
		-- vim.lsp.config(), so the full rewritten cmd is passed back.
		vim.lsp.config(name, { cmd = cmd })
	end

	tools.resolve({
		title = "LSP",
		deps = lsp_deps,
		registry = mason_ok and mason_registry or nil,
		package_of = package_of,
		binaries_of = function(name)
			local binary = server_info(name).binary
			return binary and { binary } or {}
		end,
		has_local_config = has_local_config,
		configure = function(name)
			mason_lsp_handler(name)
			rewrite_cmd_off_path(name)
		end,
	})
end

return M
