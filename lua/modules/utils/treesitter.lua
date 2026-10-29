local M = {}

-- `tree-sitter build` drives the MSVC toolchain unconditionally on Windows, so
-- no `CC` override can substitute for `cl.exe` there.
---@return boolean
function M.can_build_parsers()
	if vim.fn.executable("tree-sitter") ~= 1 then
		return false
	end
	if vim.fn.has("win32") == 1 then
		return vim.fn.executable("cl") == 1
	end
	for _, cc in ipairs({ "cc", "gcc", "clang" }) do
		if vim.fn.executable(cc) == 1 then
			return true
		end
	end
	return false
end

--- Tell the user once why parsers cannot be built, instead of letting every
--- install attempt flood the message history.
function M.notify_unbuildable()
	vim.notify(
		"nvim-treesitter: skipping parser installation, no usable `tree-sitter` CLI/toolchain found ("
			.. (vim.fn.has("win32") == 1 and "MSVC `cl.exe` is required on Windows" or "requires `cc`, `gcc` or `clang`")
			.. ").",
		vim.log.levels.WARN
	)
end

return M
