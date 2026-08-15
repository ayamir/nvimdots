local M = {}

local manifest_name = "nvimdots_manifest"
local startup_cache_files = {
	defaults = true,
	statusline = true,
	tbline = true,
}

local function cache_file(name)
	return vim.g.base46_cache .. name
end

local function load_cache_file(name)
	local file = cache_file(name)
	if vim.uv.fs_stat(file) then
		dofile(file)
	end
end

local function encode_value(value, seen)
	local value_type = type(value)
	if value_type == "nil" or value_type == "boolean" or value_type == "number" or value_type == "string" then
		return vim.inspect(value)
	end
	if value_type == "function" then
		return "<function>"
	end
	if value_type ~= "table" then
		return "<" .. value_type .. ">"
	end

	seen = seen or {}
	if seen[value] then
		return "<cycle>"
	end
	seen[value] = true

	local result = {}
	if vim.islist(value) then
		for index, item in ipairs(value) do
			result[index] = encode_value(item, seen)
		end
	else
		local keys = vim.tbl_keys(value)
		table.sort(keys, function(left, right)
			return tostring(left) < tostring(right)
		end)
		for _, key in ipairs(keys) do
			result[#result + 1] = tostring(key) .. "=" .. encode_value(value[key], seen)
		end
	end

	seen[value] = nil
	return "{" .. table.concat(result, ",") .. "}"
end

local function cache_fingerprint()
	local config = require("nvconfig")
	return encode_value({
		base46 = config.base46,
		cheatsheet = {
			theme = config.cheatsheet and config.cheatsheet.theme,
		},
		ui = {
			cmp = config.ui and config.ui.cmp,
			statusline = config.ui and {
				enabled = config.ui.statusline and config.ui.statusline.enabled,
				theme = config.ui.statusline and config.ui.statusline.theme,
			},
			telescope = config.ui and {
				style = config.ui.telescope and config.ui.telescope.style,
			},
		},
	})
end

local function read_manifest()
	local ok, lines = pcall(vim.fn.readfile, cache_file(manifest_name))
	return ok and lines[1] or nil
end

local function write_manifest(fingerprint)
	pcall(vim.fn.writefile, { fingerprint }, cache_file(manifest_name))
end

local function cache_is_current()
	return vim.uv.fs_stat(cache_file("defaults"))
		and vim.uv.fs_stat(cache_file("statusline"))
		and read_manifest() == cache_fingerprint()
end

local function load_cached_highlights(requested_files)
	requested_files = requested_files or startup_cache_files

	local ok, cache_files = pcall(vim.fn.readdir, vim.g.base46_cache)
	if not ok then
		return false
	end

	load_cache_file("defaults")
	table.sort(cache_files)
	for _, name in ipairs(cache_files) do
		if requested_files[name] and name ~= "defaults" and name ~= manifest_name then
			local loaded = pcall(dofile, cache_file(name))
			if not loaded then
				return false
			end
		end
	end

	return true
end

local function load_remaining_cached_highlights()
	local remaining = {}
	local ok, files = pcall(vim.fn.readdir, vim.g.base46_cache)
	if not ok then
		return
	end

	for _, name in ipairs(files) do
		if not startup_cache_files[name] and name ~= "colors" and name ~= "term" and name ~= manifest_name then
			remaining[name] = true
		end
	end

	load_cached_highlights(remaining)
end

local function schedule_remaining_cached_highlights()
	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("NvimdotsBase46LazyCache", { clear = true }),
		pattern = "VeryLazy",
		once = true,
		callback = load_remaining_cached_highlights,
	})
end

local function refresh_cached_highlights(base46)
	if type(base46.compile) == "function" then
		base46.compile()
		write_manifest(cache_fingerprint())
		return load_cached_highlights()
	end

	base46.load_all_highlights()
	write_manifest(cache_fingerprint())
	return true
end

function M.load()
	if not vim.g.base46_cache then
		vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
	end

	if vim.g.nvimdots_base46_loaded then
		return
	end

	local ok, base46 = pcall(require, "base46")
	if ok and cache_is_current() and load_cached_highlights() then
		schedule_remaining_cached_highlights()
		vim.g.nvimdots_base46_loaded = true
	elseif ok then
		refresh_cached_highlights(base46)
		schedule_remaining_cached_highlights()
		vim.g.nvimdots_base46_loaded = true
	else
		load_cache_file("defaults")
		load_cache_file("statusline")
		vim.g.nvimdots_base46_loaded = true
	end
end

function M.setup()
	M.load()

	require("modules.utils.nvchad_theme").setup()
end

return M
