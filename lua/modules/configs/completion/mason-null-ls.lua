local M = {}

M.setup = function()
	local null_ls = require("null-ls")
	local tools = require("modules.utils.tools")
	local null_ls_deps = require("core.settings").null_ls_deps

	-- mason-null-ls's `automatic_setup` registers only *installed* sources, so a
	-- source available on $PATH but not Mason-installed would never activate.
	-- Drive it discovery-first instead: register any available source, install
	-- those Mason can provide, and surface the rest in one warning.
	--
	-- Mason is an optional backend: guard its requires so a Mason-less setup still
	-- registers sources whose binary is on $PATH (it just can't install missing ones).
	local has_registry, mason_registry = pcall(require, "mason-registry")
	local has_map, source_map = pcall(require, "mason-null-ls.mappings.source")
	local mason_ok = has_registry and has_map
	if mason_ok then
		require("modules.utils").load_plugin("mason-null-ls", {
			ensure_installed = {},
			automatic_installation = false,
			automatic_setup = false,
			handlers = {},
		})
	end

	local methods = { "formatting", "diagnostics", "code_actions", "hover", "completion" }

	---Resolve a none-ls source to its builtin(s) and the binary it invokes.
	---Uses `pcall(require, ...)` to probe methods (as mason-null-ls does) so
	---probing the wrong method never emits a "failed to load builtin" log.
	---@param source string
	---@return table[] builtins, string|nil binary
	local function resolve_source(source)
		local builtins, binary = {}, nil
		for _, method in ipairs(methods) do
			local ok, builtin = pcall(require, string.format("null-ls.builtins.%s.%s", method, source))
			if ok and type(builtin) == "table" then
				builtins[#builtins + 1] = builtin
				if not binary then
					local command = builtin._opts and builtin._opts.command
					-- Only a string command is $PATH-probeable. A function command is
					-- resolved dynamically by none-ls, and vim.fn.executable() errors on
					-- a non-string; leave binary nil so the source is treated as needing
					-- no external binary (registered directly below).
					binary = type(command) == "string" and command or nil
				end
			end
		end
		return builtins, binary
	end

	---Register a source's builtin(s), unless it's already registered. The guard
	---preserves sources configured explicitly in `null-ls.lua` (e.g. clang_format,
	---prettier with custom filetypes/args), which run before this resolver.
	---@param source string
	---@param builtins table[]
	local function register(source, builtins)
		if null_ls.is_registered(source) then
			return
		end
		for _, builtin in ipairs(builtins) do
			null_ls.register(builtin)
		end
	end

	-- Cache each source's resolved builtins/binary so the resolver's predicates
	-- (unknown_of / has_local_config / binaries_of) and configure() share one probe.
	local resolved = {}
	local function info(source)
		if resolved[source] == nil then
			local builtins, binary = resolve_source(source)
			resolved[source] = { builtins = builtins, binary = binary }
		end
		return resolved[source]
	end

	-- Discovery-first resolution, shared with LSP and DAP. For null-ls "configure"
	-- means registering the builtin(s):
	--   * Unknown source (no matching builtin)          -> mark_unknown (fix config).
	--   * Pure-Lua builtin (no external binary)         -> register now (no install).
	--   * Available (Mason-installed / binary on $PATH) -> register now.
	--   * Not available but Mason ships a package       -> install, register on done.
	--   * No Mason package and not on $PATH             -> ask the user to install it.
	tools.resolve({
		title = "null-ls",
		deps = null_ls_deps,
		registry = mason_ok and mason_registry or nil,
		package_of = function(source)
			-- `mason_ok` only proves the module loaded; guard the private function too
			-- so a mason-null-ls version that renames it degrades to $PATH resolution
			-- instead of throwing out of the resolver.
			if not mason_ok or type(source_map.getPackageFromNullLs) ~= "function" then
				return nil
			end
			return source_map.getPackageFromNullLs(source)
		end,
		binaries_of = function(source)
			local binary = info(source).binary
			return binary and { binary } or {}
		end,
		unknown_of = function(source)
			return #info(source).builtins == 0
		end,
		has_local_config = function(source)
			local i = info(source)
			-- A pure-Lua builtin (has builtins, no external command) needs no install.
			return #i.builtins > 0 and i.binary == nil
		end,
		configure = function(source)
			register(source, info(source).builtins)
		end,
	})
end

return M
