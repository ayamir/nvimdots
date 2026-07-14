-- Discovery-first tool resolution helpers (RFC: #1293).
--
-- Treat Mason as one *installer backend* rather than a hard requirement. For
-- every external tool (LSP server, formatter/linter source, DAP adapter) the
-- resolution order is: already on $PATH (system / Mason) → installable via
-- Mason → otherwise surfaced to the user. These helpers provide the shared
-- $PATH check, a per-subsystem warning aggregator, and a single resolution loop
-- (`M.resolve`) so "please install this yourself" is reported once, not once per
-- missing tool, and all three subsystems share one refresh-aware,
-- install-then-configure, self-validating code path.
local M = {}

-- Cross-subsystem install de-duplication. A single Mason package can back more
-- than one desired tool (e.g. a tool that is both an LSP server and a null-ls
-- source). Without this, two subsystems racing to install the same package trip
-- mason's `assert(not self:is_installing())`. Keyed by package name -> the
-- in-flight install handle, cleared when that install closes.
---@type table<string, table>
local installing = {}

---Return true if any of the given executable names is found on $PATH.
---@param names string|string[] @A single executable name or a list of them.
---@return boolean
function M.any_executable(names)
	if type(names) == "string" then
		names = { names }
	end
	if type(names) ~= "table" then
		return false
	end
	for _, name in ipairs(names) do
		if type(name) == "string" and name ~= "" and vim.fn.executable(name) == 1 then
			return true
		end
	end
	return false
end

---Create a collector that aggregates tools which could not be set up automatically
---into a single deferred warning. This avoids spamming one notification per tool.
---Entries fall into two classes, rendered as separate sections so the guidance
---matches the cause:
---  * `mark`         — a tool that couldn't be set up: not available (install it /
---                     put it on $PATH) or its configuration failed. An optional
---                     `reason` is rendered inline so config-time `error()`
---                     messages from client/server configs are surfaced.
---  * `mark_unknown` — a configured name we don't recognize (likely a typo, or an
---                     outdated or unsupported name; may be a package, server,
---                     adapter, or source name); the fix is to correct the config,
---                     not a manual install.
---
---Usage:
---  local c = tools.missing_collector("LSP")
---  c.mark("dartls")                            -- unresolved tool (sync)
---  c.mark("delve", "dlv not found on $PATH")   -- unresolved tool with reason
---  c.mark_unknown("gpls")                      -- unknown / typo'd name (sync)
---  c.track(pkg, "gopls", recheck, on_ready)    -- async install; recheck() => available?
---  c.done()                                    -- flush (handles the no-async case)
---@param title string @Notification title identifying the subsystem.
---@return { mark: fun(name: string, reason?: string), mark_unknown: fun(name: string), track: fun(pkg, name, recheck, on_ready?), done: fun() }
function M.missing_collector(title)
	local missing = {}
	local reasons = {}
	local unknown = {}
	local queued = {}
	local seen = {}
	local pending = 0
	local flushed = false

	-- Record a name into a bucket once: ignore non-strings/empties and de-duplicate
	-- (across both buckets) so the aggregated notification stays stable regardless
	-- of how callers invoke it.
	local function record(bucket, name)
		if type(name) ~= "string" or name == "" or seen[name] then
			return false
		end
		seen[name] = true
		bucket[#bucket + 1] = name
		return true
	end
	local function add(name, reason)
		if record(missing, name) and type(reason) == "string" and reason ~= "" then
			reasons[name] = reason
		end
	end
	local function add_unknown(name)
		record(unknown, name)
	end

	local function render(name)
		local reason = reasons[name]
		return reason and (name .. " — " .. reason) or name
	end

	local function flush()
		if flushed or pending > 0 then
			return
		end
		flushed = true
		if #missing == 0 and #unknown == 0 then
			return
		end
		local sections = {}
		if #missing > 0 then
			table.sort(missing)
			local lines = {}
			for _, name in ipairs(missing) do
				lines[#lines + 1] = render(name)
			end
			sections[#sections + 1] = "The following tools could not be set up automatically.\n"
				.. "Install them / ensure they are on $PATH, or check their configuration\n"
				.. "for errors:\n  • "
				.. table.concat(lines, "\n  • ")
		end
		if #unknown > 0 then
			table.sort(unknown)
			sections[#sections + 1] = "The following names are not recognized (likely a typo, or an outdated\n"
				.. "or unsupported name) — correct or remove them from your config:\n  • "
				.. table.concat(unknown, "\n  • ")
		end
		local message = table.concat(sections, "\n\n")
		vim.schedule(function()
			vim.notify(message, vim.log.levels.WARN, { title = title })
		end)
	end

	return {
		---Record a tool that could not be resolved (not installable / not confirmed).
		---An optional `reason` (e.g. a config `error()` message) is rendered inline.
		mark = add,
		---Record a configured name we don't recognize (typo / outdated / unsupported).
		mark_unknown = add_unknown,
		---Track an async Mason install for `pkg`; `recheck()` must report final
		---availability and `on_ready()` (optional) reconfigures the tool on success.
		---Guards:
		---  * If the package is already installing (another subsystem this session,
		---    or a manual/prior Mason install), attach to the existing handle instead
		---    of calling `pkg:install()` again (which would trip mason's
		---    "already installing" assert) and don't mis-mark it missing.
		---  * If `pkg:install()` errors or returns a handle without `:once`, the tool
		---    is recorded as missing instead of aborting the caller's loop.
		track = function(pkg, name, recheck, on_ready)
			local pkg_name = type(pkg) == "table" and pkg.name or nil
			local handle = pkg_name and installing[pkg_name] or nil

			-- Already being installed elsewhere: reuse its handle so we still run
			-- recheck()/on_ready() when it finishes, without starting a duplicate
			-- install. Covers cross-subsystem shared packages and manual/prior installs.
			if not handle and type(pkg.is_installing) == "function" then
				local ok_ing, is_ing = pcall(function()
					return pkg:is_installing()
				end)
				if ok_ing and is_ing and type(pkg.get_install_handle) == "function" then
					local ok_h, opt = pcall(function()
						return pkg:get_install_handle()
					end)
					if ok_h and type(opt) == "table" and type(opt.if_present) == "function" then
						opt:if_present(function(h)
							handle = h
						end)
					end
				end
			end

			if not handle then
				local ok, h = pcall(function()
					return pkg:install()
				end)
				if not ok or type(h) ~= "table" or type(h.once) ~= "function" then
					add(name)
					return
				end
				handle = h
				if pkg_name then
					installing[pkg_name] = handle
				end
			elseif type(handle.once) ~= "function" then
				-- Shared handle isn't usable (unexpected shape); mark rather than hang.
				add(name)
				return
			end

			pending = pending + 1
			-- Only queue a real string for the aggregated INFO: a non-string name (a
			-- misconfigured deps entry) would make done()'s table.sort(queued) error and
			-- suppress both notifications. Track whether we appended so the throw path
			-- below pops the right entry.
			local queued_here = type(name) == "string" and name ~= ""
			if queued_here then
				queued[#queued + 1] = name
			end
			-- Mason fires "closed" from a luv callback (fast event context) where
			-- Vim APIs used by recheck()/on_ready() are unsafe; run the handler on the
			-- main loop via vim.schedule_wrap. Both are pcall'd and pending is
			-- decremented unconditionally so a throwing callback can't leave pending
			-- stuck > 0 and permanently suppress the aggregated warning.
			local registered = pcall(
				handle.once,
				handle,
				"closed",
				vim.schedule_wrap(function()
					if pkg_name then
						installing[pkg_name] = nil
					end
					local rc_ok, available = pcall(recheck)
					if rc_ok and available then
						if type(on_ready) == "function" then
							pcall(on_ready)
						end
					else
						add(name)
					end
					pending = pending - 1
					flush()
				end)
			)
			-- If once() itself threw, no decrementing callback ever attached; undo the
			-- accounting so a failed registration can't leave pending > 0 (which would
			-- permanently suppress the aggregated warning). Drop the cached handle too,
			-- or later resolutions would reuse it forever (never retrying the install).
			if not registered then
				pending = pending - 1
				if queued_here then
					queued[#queued] = nil
				end
				if pkg_name then
					installing[pkg_name] = nil
				end
				add(name)
			end
		end,
		---Flush the aggregated warning once all tracked installs have settled.
		done = function()
			-- One aggregated INFO (not one-per-tool) so a first launch shows progress
			-- and a "relaunch" hint instead of silently downloading in the background.
			if #queued > 0 then
				table.sort(queued)
				local message = string.format(
					"Installing %d tool(s) via Mason in the background; each is configured\n"
						.. "automatically once its install finishes (relaunch if one isn't picked up):\n  • %s",
					#queued,
					table.concat(queued, "\n  • ")
				)
				vim.schedule(function()
					vim.notify(message, vim.log.levels.INFO, { title = title })
				end)
			end
			flush()
		end,
	}
end

---Collect the executable name(s) a Mason package provides, from its spec.
---Falls back to the package name when the spec declares no `bin` table.
---@param pkg table @A mason-registry Package object.
---@param fallback string @Name to use when `pkg.spec.bin` is absent.
---@return string[]
function M.package_binaries(pkg, fallback)
	local bins = {}
	if type(pkg.spec) == "table" and type(pkg.spec.bin) == "table" then
		for bin_name, _ in pairs(pkg.spec.bin) do
			bins[#bins + 1] = bin_name
		end
	end
	if #bins == 0 then
		bins = { fallback }
	end
	return bins
end

---Mason's package install root, or nil when Mason isn't available. Prefers the
---settings API (authoritative and present as soon as mason is required) over the
---`$MASON` env var, which is only set as a side effect of `mason.setup()` and may
---not be exported at all. The resolved root is confirmed to exist on disk so the
---"nil when Mason is unavailable" contract holds for a fresh (never-bootstrapped)
---setup, where the setting/env may point at a directory that isn't there yet.
---@return string|nil
function M.mason_root()
	local root
	local ok, settings = pcall(require, "mason.settings")
	if ok and settings.current and type(settings.current.install_root_dir) == "string" then
		root = settings.current.install_root_dir
	else
		root = vim.env.MASON
	end
	if type(root) == "string" and root ~= "" and vim.uv.fs_stat(root) then
		return root
	end
	return nil
end

---Shared discovery-first resolution loop for a subsystem's desired tools.
---
---For each entry in `spec.deps` the resolution order is:
---  0. Unrecognized name (`unknown_of`)          -> ask the user to fix the config
---     (a null-ls source with no matching builtin, say); never install.
---  1. Available now (Mason-installed or a binary on $PATH) -> configure now.
---  2. Not available but a Mason package exists   -> install, then configure on
---     completion (never configured with an unresolved binary).
---  3. No Mason package but a local config exists -> configure now; the
---     client/server config self-validates its binary and `error()`s if absent,
---     surfaced (with the message) as missing. A pure-Lua null-ls builtin (no
---     external binary) also lands here and is registered directly.
---  4. Otherwise                                  -> ask the user to install it
---     (or `mark_unknown` when the Mason mapping is stale).
---
---The whole loop runs inside `registry.refresh(...)` so Mason's package specs /
---mappings are loaded even on a fresh (never-bootstrapped) setup; without a
---registry it runs immediately. `configure` is optional (formatters/linters just
---install-or-warn) and is always pcall'd so one failing setup can't abort the rest.
---@param spec {
---  title: string,
---  deps: string[],
---  registry: table|nil,
---  package_of: fun(name: string): string|nil,
---  binaries_of: fun(name: string, pkg: table|nil): string[],
---  unknown_of?: fun(name: string): boolean,
---  has_local_config?: fun(name: string): boolean,
---  configure?: fun(name: string),
---}
function M.resolve(spec)
	local collector = M.missing_collector(spec.title)
	local registry = spec.registry

	-- Configure one tool, surfacing a config-time error (e.g. a client config that
	-- can't find its binary) as a missing entry annotated with the error message.
	local function do_configure(name)
		if type(spec.configure) ~= "function" then
			return
		end
		local ok, err = pcall(spec.configure, name)
		if not ok then
			local reason
			if type(err) == "string" then
				-- Strip Lua's "chunkname:line: " position prefix that `error(msg)` adds,
				-- so the aggregated warning reads "delve — dlv not found …" rather than
				-- "delve — …/delve.lua:17: dlv not found …".
				reason = (err:gsub("^[^\n]-:%d+: ", ""))
			end
			collector.mark(name, reason)
		end
	end

	local function resolve_one(name)
		-- Unrecognized name: the fix is to correct the config, not install anything.
		-- Checked first so a typo is never misreported as a missing/installable tool.
		if spec.unknown_of and spec.unknown_of(name) then
			collector.mark_unknown(name)
			return
		end

		local pkg_name = spec.package_of(name)
		local pkg, pkg_unknown = nil, false
		if pkg_name and registry then
			local ok, resolved = pcall(registry.get_package, pkg_name)
			if ok then
				pkg = resolved
			else
				-- Mapping points at a Mason package the registry doesn't have (stale
				-- mapping / registry skew). Fall through to $PATH / local-config below;
				-- only if nothing else resolves it do we report the bad mapping.
				pkg_unknown = true
			end
		end

		local binaries = spec.binaries_of(name, pkg)
		local available = (pkg ~= nil and pkg:is_installed()) or M.any_executable(binaries)

		-- Not available yet but Mason ships a package: install in the background and
		-- only configure once the binary is available, so an adapter/server is never
		-- registered with an empty command.
		if not available and pkg ~= nil then
			collector.track(pkg, name, function()
				return pkg:is_installed() or M.any_executable(spec.binaries_of(name, pkg))
			end, function()
				do_configure(name)
			end)
			return
		end

		-- Configure now when the tool is available, or when a local config exists: the
		-- local config is the tool's own discovery-first resolver ($PATH / system /
		-- venv) and self-validates, `error()`ing when its binary is absent, which
		-- do_configure surfaces as missing (with the message). A pure-Lua null-ls
		-- builtin (no binary, `has_local_config` true) is likewise registered here.
		if available or (spec.has_local_config and spec.has_local_config(name)) then
			do_configure(name)
		elseif pkg_unknown then
			collector.mark_unknown(pkg_name == name and name or (pkg_name .. " (for " .. name .. ")"))
		else
			collector.mark(name)
		end
	end

	local function run()
		for _, name in ipairs(spec.deps) do
			resolve_one(name)
		end
		collector.done()
	end

	if registry and type(registry.refresh) == "function" then
		-- refresh() calls back synchronously when the cache is fresh (the common
		-- case) and asynchronously — from a fast event context — when it actually
		-- updates. Defer to the main loop only in the latter case so synchronous
		-- resolution (e.g. DAP adapters needed immediately after `:DapContinue`)
		-- isn't needlessly pushed to the next tick.
		registry.refresh(function()
			if vim.in_fast_event() then
				vim.schedule(run)
			else
				run()
			end
		end)
	else
		run()
	end
end

return M
