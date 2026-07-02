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
					binary = builtin._opts and builtin._opts.command
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

	-- Discovery-first resolution per desired source:
	--   1. Mason ships a package but it isn't available yet -> install (next launch).
	--   2. Available now (Mason-installed / binary on $PATH) -> register the builtin.
	--   3. No Mason package and not on $PATH                 -> ask the user to install it.
	local collector = tools.missing_collector("null-ls")

	for _, source in ipairs(null_ls_deps) do
		local builtins, binary = resolve_source(source)
		local pkg_name = mason_ok and source_map.getPackageFromNullLs(source) or nil
		local pkg
		if pkg_name then
			local ok, resolved = pcall(mason_registry.get_package, pkg_name)
			pkg = ok and resolved or nil
		end

		local installed = pkg ~= nil and pkg:is_installed()
		local on_path = binary ~= nil and vim.fn.executable(binary) == 1

		if #builtins == 0 then
			-- Unknown source name (typo / renamed): nothing to register or install.
			-- Surface it as an unknown name so the warning points at the config,
			-- not a manual install.
			collector.mark_unknown(source)
		elseif pkg ~= nil and not (installed or on_path) then
			collector.track(pkg, source, function()
				return pkg:is_installed() or (binary ~= nil and vim.fn.executable(binary) == 1)
			end)
		elseif installed or on_path then
			register(source, builtins)
		else
			collector.mark(source)
		end
	end

	collector.done()
end

return M
