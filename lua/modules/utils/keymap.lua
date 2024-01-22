local M = {}

---Shortcut for `nvim_replace_termcodes`.
---@param keys string
---@return string
local function termcodes(keys)
	return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

---Returns if two key sequence are equal or not.
---@param a string
---@param b string
---@return boolean
local function keymap_equals(a, b)
	return termcodes(a) == termcodes(b)
end

---Get map
---@param mode string
---@param lhs string
---@return table
local function get_map(mode, lhs)
	for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
		if keymap_equals(map.lhs, lhs) then
			vim.api.nvim_buf_del_keymap(0, mode, lhs)
			return {
				lhs = map.lhs,
				rhs = map.rhs or "",
				expr = map.expr == 1,
				callback = map.callback,
				noremap = map.noremap == 1,
				script = map.script == 1,
				silent = map.silent == 1,
				nowait = map.nowait == 1,
				buffer = true,
			}
		end
	end

	for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
		if keymap_equals(map.lhs, lhs) then
			vim.api.nvim_del_keymap(mode, lhs)
			return {
				lhs = map.lhs,
				rhs = map.rhs or "",
				expr = map.expr == 1,
				callback = map.callback,
				noremap = map.noremap == 1,
				script = map.script == 1,
				silent = map.silent == 1,
				nowait = map.nowait == 1,
				buffer = false,
			}
		end
	end

	return {
		lhs = lhs,
		rhs = lhs,
		expr = false,
		callback = nil,
		noremap = true,
		script = false,
		silent = true,
		nowait = false,
		buffer = false,
	}
end

---Returns the function constructed from the passed keymap object on call of
---which the original keymapping will be executed.
---@param map table keymap object
---@return function
local function get_fallback(map)
	return function()
		local keys, fmode
		if map.expr then
			if map.callback then
				keys = map.callback()
			else
				keys = vim.api.nvim_eval(map.rhs)
			end
		elseif map.callback then
			map.callback()
			return
		else
			keys = map.rhs
		end
		keys = termcodes(keys)
		fmode = map.noremap and "in" or "im"
		vim.api.nvim_feedkeys(keys, fmode, false)
	end
end

-- Amends a mapping (i.e., allows fallback when certain conditions are met)
---@param cond string
---@param mode string
---@param lhs string
---@param rhs function
---@param opts? table
local function amend(cond, mode, lhs, rhs, opts)
	local map = get_map(mode, lhs)
	local fallback = get_fallback(map)
	local options = vim.deepcopy(opts) or {}
	options.desc = table.concat({
		"[" .. cond,
		(options.desc and ": " .. options.desc or ""),
		"]",
		(map.desc and " / " .. map.desc or ""),
	})
	vim.keymap.set(mode, lhs, function()
		rhs(fallback)
	end, options)
end

-- Completely replace a mapping
---@param mode string
---@param lhs string
---@param rhs string
---@param opts? table
---@param buf? boolean|number
local function replace(mode, lhs, rhs, opts, buf)
	get_map(mode, lhs)

	local options = vim.deepcopy(opts) or {}
	if buf and type(buf) == "number" then
		vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
	else
		vim.api.nvim_set_keymap(mode, lhs, rhs, options)
	end
end

---Amend the existing keymap.
---@param cond string
---@param mode string | string[]
---@param lhs string
---@param rhs function
---@param opts? table
local function modes_amend(cond, mode, lhs, rhs, opts)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			amend(cond, m, lhs, rhs, opts)
		end
	else
		amend(cond, mode, lhs, rhs, opts)
	end
end

---Replace the existing keymap.
---@param mode string | string[]
---@param lhs string
---@param rhs string
---@param opts? table
---@param buf? boolean|number
local function modes_replace(mode, lhs, rhs, opts, buf)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			replace(m, lhs, rhs, opts, buf)
		end
	else
		replace(mode, lhs, rhs, opts, buf)
	end
end

---Amend the existing keymap.
---@param cond string
---@param global_flag string
---@param mapping table<string, map_rhs>
function M.amend(cond, global_flag, mapping)
	for key, value in pairs(mapping) do
		local modes, keymap = key:match("([^|]*)|?(.*)")
		if type(value) == "table" then
			local rhs = value.cmd
			local options = value.options
			modes_amend(cond, vim.split(modes, ""), keymap, function(fallback)
				if _G[global_flag] then
					local fmode = options.noremap and "in" or "im"
					vim.api.nvim_feedkeys(termcodes(rhs), fmode, false)
				else
					fallback()
				end
			end, options)
		end
	end
end

---Replace the existing keymap.
---@param mapping table<string, map_rhs>
function M.replace(mapping)
	for key, value in pairs(mapping) do
		local modes, keymap = key:match("([^|]*)|?(.*)")
		if type(value) == "table" then
			local rhs = value.cmd
			local options = value.options
			local buffer = value.buffer
			modes_replace(vim.split(modes, ""), keymap, rhs, options, buffer)
		elseif value == "" or value == false then
			for _, m in ipairs(vim.split(modes, "")) do
				get_map(m, keymap)
			end
		end
	end
end

return M
