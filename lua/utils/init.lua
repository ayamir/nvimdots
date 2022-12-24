local M = {}

---@param c  string
local function hexToRgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(foreground, background, alpha)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = hexToRgb(background)
	local fg = hexToRgb(foreground)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

--- Get hex by highlight group
---@param hl_group string highlight group name
---@param use_bg boolean
---@return string
function M.hlToRgb(hl_group, use_bg)
	if use_bg == true then
		local color = vim.api.nvim_get_hl_by_name(hl_group, true).background
		local hex = color ~= nil and string.format("#%06x", color) or "#000000"
		return hex
	else
		local color = vim.api.nvim_get_hl_by_name(hl_group, true).foreground
		local hex = color ~= nil and string.format("#%06x", color) or "#111111"
		return hex
	end
end

return M
