local M = {}

---@param c string @The color in hexadecimal.
local function hexToRgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

--- Blend foreground with background
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
function M.hl_to_rgb(hl_group, use_bg, fallback_hl)
	local hex = fallback_hl or "#000000"
	local hlexists = M.tobool(tonumber(vim.api.nvim_exec('echo hlexists("' .. hl_group .. '")', true)))

	if use_bg then
		if hlexists then
			local bg = vim.api.nvim_get_hl_by_name(hl_group, true).background or "NONE"
			hex = bg == "NONE" and bg or string.format("#%06x", bg)
		end
		return hex
	else
		if hlexists then
			local fg = vim.api.nvim_get_hl_by_name(hl_group, true).foreground or "NONE"
			hex = fg == "NONE" and fg or string.format("#%06x", fg)
		end
		return hex
	end
end

--- Extend a highlight group
---@param name string @Target highlight group name
---@param def table @Attributes to be extended
function M.extend_hl(name, def)
	local hlexists = M.tobool(tonumber(vim.api.nvim_exec('echo hlexists("' .. name .. '")', true)))
	if not hlexists then
		-- Do nothing if highlight group not found
		return
	end
	local current_def = vim.api.nvim_get_hl_by_name(name, true)
	local combined_def = vim.tbl_deep_extend("force", current_def, def)

	vim.api.nvim_set_hl(0, name, combined_def)
end

--- Convert number (0/1) to boolean
---@param value number? @The value to check, can be nil (API Error)
---@return boolean|nil
function M.tobool(value)
	if value == 0 or value == nil then
		return false
	elseif value == 1 then
		return true
	else
		vim.notify(
			"Attempt to convert data of type '" .. type(value) .. "' [other than 0 or 1] to boolean",
			vim.log.levels.ERROR,
			{ title = "[utils] Runtime error" }
		)
		return nil
	end
end

return M
