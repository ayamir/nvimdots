local M = {}

local xor = function(bool, a, b)
	if bool then
		return a
	else
		return b
	end
end

local format_disabled_var = function()
	return string.format("format_disabled_%s", vim.bo.filetype)
end
local format_options_var = function()
	return string.format("format_options_%s", vim.bo.filetype)
end

M.formatToggle = function(value)
	local var = format_disabled_var()
	vim.g[var] = xor(value ~= nil, value, not vim.g[var])
end
vim.cmd([[command! FormatDisable lua require'modules.completion.formatting'.formatToggle(true)]])
vim.cmd([[command! FormatEnable lua require'modules.completion.formatting'.formatToggle(false)]])

M.format = function()
	if not vim.b.saving_format and not vim.g[format_disabled_var()] then
		vim.b.init_changedtick = vim.b.changedtick
		vim.lsp.buf.formatting(vim.g[format_options_var()] or {})
	end
end

return M
