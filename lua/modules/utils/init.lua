local M = {}

---@param c string @The color in hexadecimal.
local function hexToRgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string @The foreground color
---@param background string @The background color to blend with
---@param alpha number|string @Number between 0 and 1 for blending amount.
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

--- Get RGB highlight by highlight group
---@param hl_group string @Highlight group name
---@param use_bg boolean @Returns background or not
---@param fallback_hl? string @Fallback value if the hl group is not defined
---@return string
function M.hlToRgb(hl_group, use_bg, fallback_hl)
	fallback_hl = fallback_hl or "#D9E0ED"

	if use_bg == true then
		local color = vim.api.nvim_get_hl_by_name(hl_group, true).background
		local hex = color ~= nil and string.format("#%06x", color) or fallback_hl
		return hex
	else
		local color = vim.api.nvim_get_hl_by_name(hl_group, true).foreground
		local hex = color ~= nil and string.format("#%06x", color) or fallback_hl
		return hex
	end
end

function M.extend_hl(name, def)
	local current_def = vim.api.nvim_get_hl_by_name(name, true)
	if current_def == nil then
		-- Do nothing if highlight group not found
		return
	end
	local combined_def = vim.tbl_extend("force", current_def, def)

	vim.api.nvim_set_hl(0, name, combined_def)
end

return M
