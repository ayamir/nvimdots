---@class map_rhs
---@field cmd string
---@field options table
---@field options.noremap boolean
---@field options.silent boolean
---@field options.expr boolean
---@field options.nowait boolean
---@field options.callback function
---@field options.desc string
---@field buffer boolean|number
local rhs_options = {}

function rhs_options:new()
	local instance = {
		cmd = "",
		options = {
			noremap = false,
			silent = false,
			expr = false,
			nowait = false,
			callback = nil,
			desc = "",
		},
		buffer = false,
	}
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_cmd(cmd_string)
	self.cmd = cmd_string
	return self
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_cr(cmd_string)
	self.cmd = (":%s<CR>"):format(cmd_string)
	return self
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_args(cmd_string)
	self.cmd = (":%s<Space>"):format(cmd_string)
	return self
end

---@param cmd_string string
---@return map_rhs
function rhs_options:map_cu(cmd_string)
	-- <C-u> to eliminate the automatically inserted range in visual mode
	self.cmd = (":<C-u>%s<CR>"):format(cmd_string)
	return self
end

---@param callback fun():nil
--- Takes a callback that will be called when the key is pressed
---@return map_rhs
function rhs_options:map_callback(callback)
	self.cmd = ""
	self.options.callback = callback
	return self
end

---@return map_rhs
function rhs_options:with_silent()
	self.options.silent = true
	return self
end

---@param description_string string
---@return map_rhs
function rhs_options:with_desc(description_string)
	self.options.desc = description_string
	return self
end

---@return map_rhs
function rhs_options:with_noremap()
	self.options.noremap = true
	return self
end

---@return map_rhs
function rhs_options:with_expr()
	self.options.expr = true
	return self
end

---@return map_rhs
function rhs_options:with_nowait()
	self.options.nowait = true
	return self
end

---@param num number
---@return map_rhs
function rhs_options:with_buffer(num)
	self.buffer = num
	return self
end

local bind = {}

---@param cmd_string string
---@return map_rhs
function bind.map_cr(cmd_string)
	local ro = rhs_options:new()
	return ro:map_cr(cmd_string)
end

---@param cmd_string string
---@return map_rhs
function bind.map_cmd(cmd_string)
	local ro = rhs_options:new()
	return ro:map_cmd(cmd_string)
end

---@param cmd_string string
---@return map_rhs
function bind.map_cu(cmd_string)
	local ro = rhs_options:new()
	return ro:map_cu(cmd_string)
end

---@param cmd_string string
---@return map_rhs
function bind.map_args(cmd_string)
	local ro = rhs_options:new()
	return ro:map_args(cmd_string)
end

---@param callback fun():nil
---@return map_rhs
function bind.map_callback(callback)
	local ro = rhs_options:new()
	return ro:map_callback(callback)
end

---@param cmd_string string
---@return string escaped_string
function bind.escape_termcode(cmd_string)
	return vim.api.nvim_replace_termcodes(cmd_string, true, true, true)
end

local last_prefix_to_register = ""

---@param mapping table<string, map_rhs>
function bind.nvim_load_mapping(mapping)
	for key, value in pairs(mapping) do
		local modes, keymap = key:match("([^|]*)|?(.*)")
		if type(value) == "table" then
			for _, mode in ipairs(vim.split(modes, "")) do
				local rhs = value.cmd
				local buf = value.buffer
				local options = value.options
				local begin_with_leader = keymap:sub(1, #"<leader>") == "<leader>"
				local grouped_keymap = #keymap > #"<leader>x"
				local should_register = begin_with_leader and grouped_keymap
				local start_index, end_index = string.find(keymap:sub(#"<leader>"), "<(.-)>")
				local prefix_length = #"<leader>x"
				if start_index and end_index then
					prefix_length = prefix_length + end_index - start_index
				end
				local prefix_to_register = keymap:sub(1, prefix_length)
				if last_prefix_to_register ~= "" then
					local repeat_register = last_prefix_to_register ~= prefix_to_register
					should_register = should_register and not repeat_register
				end
				last_prefix_to_register = prefix_to_register
				if buf and type(buf) == "number" then
					vim.api.nvim_buf_set_keymap(buf, mode, keymap, rhs, options)
					if should_register then
						require("modules.utils.keymap").insert_queue(prefix_to_register, mode, buf)
					end
				else
					vim.api.nvim_set_keymap(mode, keymap, rhs, options)
					if should_register then
						require("modules.utils.keymap").insert_queue(prefix_to_register, mode, nil)
					end
				end
			end
		end
	end
end

return bind
