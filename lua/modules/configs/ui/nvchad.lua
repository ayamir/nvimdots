local M = {}

local function cache_file(name)
	return vim.g.base46_cache .. name
end

local function load_cache_file(name)
	local file = cache_file(name)
	if vim.uv.fs_stat(file) then
		dofile(file)
	end
end

function M.load()
	if not vim.g.base46_cache then
		vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
	end

	local ok, base46 = pcall(require, "base46")
	if ok then
		base46.load_all_highlights()
	else
		load_cache_file("defaults")
		load_cache_file("statusline")
	end
end

function M.setup()
	M.load()

	require("modules.utils.nvchad_theme").setup()
end

return M
