-- Discovery-first tool resolution helpers (RFC: #1293).
--
-- Treat Mason as one *installer backend* rather than a hard requirement. For
-- every external tool (LSP server, formatter/linter source, DAP adapter) the
-- resolution order is: already on $PATH (system / Mason) → installable via
-- Mason → otherwise surfaced to the user. These helpers provide the shared
-- $PATH check, a Mason package -> binary resolver, and a per-subsystem warning
-- aggregator so "please install this yourself" is reported once, not once per
-- missing tool.
local M = {}

---Return true if any of the given executable names is found on $PATH.
---@param names string|string[] @A single executable name or a list of them.
---@return boolean
function M.any_executable(names)
	if type(names) == "string" then
		names = { names }
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
---                     put it on $PATH) or its configuration failed.
---  * `mark_unknown` — a configured name we don't recognize (likely a typo, or an
---                     outdated or unsupported name; may be a package, server,
---                     adapter, or source name); the fix is to correct the config,
---                     not a manual install.
---
---Usage:
---  local c = tools.missing_collector("LSP")
---  c.mark("dartls")                   -- unresolved tool (sync)
---  c.mark_unknown("gpls")             -- unknown / typo'd name (sync)
---  c.track(pkg, "gopls", recheck)     -- async install; recheck() => available?
---  c.done()                           -- flush (handles the no-async case)
---@param title string @Notification title identifying the subsystem.
---@return { mark: fun(name: string), mark_unknown: fun(name: string), track: fun(pkg: table, name: string, recheck: fun(): boolean), done: fun() }
function M.missing_collector(title)
	local missing = {}
	local unknown = {}
	local seen = {}
	local pending = 0
	local flushed = false

	-- Record a name into a bucket once: ignore non-strings/empties and de-duplicate
	-- (across both buckets) so the aggregated notification stays stable regardless
	-- of how callers invoke it.
	local function record(bucket, name)
		if type(name) ~= "string" or name == "" or seen[name] then
			return
		end
		seen[name] = true
		bucket[#bucket + 1] = name
	end
	local function add(name)
		record(missing, name)
	end
	local function add_unknown(name)
		record(unknown, name)
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
			sections[#sections + 1] = "The following tools could not be set up automatically.\n"
				.. "Install them / ensure they are on $PATH, or check their configuration\n"
				.. "for errors:\n  • "
				.. table.concat(missing, "\n  • ")
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
		mark = add,
		---Record a configured name we don't recognize (typo / outdated / unsupported).
		mark_unknown = add_unknown,
		---Track an async Mason install for `pkg`; `recheck()` must report final
		---availability. The install call is guarded: if `pkg:install()` errors or
		---returns a handle without `:once`, the tool is recorded as missing instead
		---of aborting the caller's resolution loop (keeps "Mason is optional" robust).
		track = function(pkg, name, recheck)
			local ok, handle = pcall(function()
				return pkg:install()
			end)
			if not ok or type(handle) ~= "table" or type(handle.once) ~= "function" then
				add(name)
				return
			end
			pending = pending + 1
			-- Mason fires "closed" from a luv callback (fast event context) where
			-- Vim APIs used by recheck() (e.g. vim.fn.executable) are unsafe; run the
			-- handler on the main loop via vim.schedule_wrap. recheck() is pcall'd and
			-- pending is decremented unconditionally so a throwing recheck can't leave
			-- pending stuck > 0 and permanently suppress the aggregated warning.
			handle:once(
				"closed",
				vim.schedule_wrap(function()
					local rc_ok, available = pcall(recheck)
					if not rc_ok or not available then
						add(name)
					end
					pending = pending - 1
					flush()
				end)
			)
		end,
		---Flush the aggregated warning once all tracked installs have settled.
		done = function()
			flush()
		end,
	}
end

---Collect the executable name(s) a Mason package provides, from its spec.
---Falls back to the given name when the spec declares no `bin` table.
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
---not be exported at all.
---@return string|nil
function M.mason_root()
	local ok, settings = pcall(require, "mason.settings")
	if ok and settings.current and type(settings.current.install_root_dir) == "string" then
		return settings.current.install_root_dir
	end
	return vim.env.MASON
end

return M
