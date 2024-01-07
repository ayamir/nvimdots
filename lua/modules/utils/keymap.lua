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

--- Register queued which-key mappings
function M.which_key_register()
	if M.which_key_queue then
		local wk_avail, wk = pcall(require, "which-key")
		if wk_avail then
			for mode, registration in pairs(M.which_key_queue) do
				wk.register(registration, { mode = mode })
			end
			M.which_key_queue = nil
		end
	end
end

--- Get an empty table of mappings with a key for each map mode
---@return table<string,table> # a table with entries for each map mode
function M.empty_map_table()
	local maps = {}
	for _, mode in ipairs({ "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t" }) do
		maps[mode] = {}
	end
	if vim.fn.has("nvim-0.10.0") == 1 then
		for _, abbr_mode in ipairs({ "ia", "ca", "!a" }) do
			maps[abbr_mode] = {}
		end
	end
	return maps
end

--- Table based API for setting keybindings
---@param map_table table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? table A base set of options to set on every keybinding
function M.set_mappings(map_table, base)
	-- iterate over the first keys for each mode
	base = base or {}
	for mode, maps in pairs(map_table) do
		-- iterate over each keybinding set in the current mode
		for keymap, options in pairs(maps) do
			-- build the options for the command accordingly
			if options then
				local cmd = options
				local keymap_opts = base
				if type(options) == "table" then
					cmd = options[1]
					keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
					keymap_opts[1] = nil
				end
				if not cmd or keymap_opts.name then -- if which-key mapping, queue it
					if not keymap_opts.name then
						keymap_opts.name = keymap_opts.desc
					end
					if not M.which_key_queue then
						M.which_key_queue = {}
					end
					if not M.which_key_queue[mode] then
						M.which_key_queue[mode] = {}
					end
					M.which_key_queue[mode][keymap] = keymap_opts
				else -- if not which-key mapping, set it
					vim.keymap.set(mode, keymap, cmd, keymap_opts)
				end
			end
		end
	end
	if package.loaded["which-key"] then
		M.which_key_register()
	end -- if which-key is loaded already, register
end

return M
