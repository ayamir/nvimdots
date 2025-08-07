local M = {}

---Setup and enable a language server in one call.
---@param server string @Name of the language server
---@param config? vim.lsp.Config @Optional config to apply
function M.register_server(server, config)
	vim.validate("server", server, "string", false)
	vim.validate("config", config, "table", true)

	if config then
		vim.lsp.config(server, config)
	end
	vim.lsp.enable(server)
end

--- Function to recursively merge src into dst
--- Unlike vim.tbl_deep_extend(), this function extends if the original value is a list
---@paramm dst table @Table which will be modified and appended to
---@paramm src table @Table from which values will be inserted
---@return table @Modified table
local function tbl_recursive_merge(dst, src)
	for key, value in pairs(src) do
		if type(dst[key]) == "table" and type(value) == "function" then
			dst[key] = value(dst[key])
		elseif type(dst[key]) == "table" and vim.islist(dst[key]) and key ~= "dashboard_image" then
			vim.list_extend(dst[key], value)
		elseif type(dst[key]) == "table" and type(value) == "table" and not vim.islist(dst[key]) then
			tbl_recursive_merge(dst[key], value)
		else
			dst[key] = value
		end
	end
	return dst
end

-- Function to extend existing core configs (settings, events, etc.)
---@param config table @The default config to be merged with
---@param user_config string @The module name used to require user config
---@return table @Extended config
function M.extend_config(config, user_config)
	local ok, extras = pcall(require, user_config)
	if ok and type(extras) == "table" then
		config = tbl_recursive_merge(config, extras)
	end
	return config
end

---@param plugin_name string @Module name of the plugin (used to setup itself)
---@param opts nil|table @The default config to be merged with
---@param vim_plugin? boolean @If this plugin is written in vimscript or not
---@param setup_callback? function @Add new callback if the plugin needs unusual setup function
function M.load_plugin(plugin_name, opts, vim_plugin, setup_callback)
	vim_plugin = vim_plugin or false

	-- Get the file name of the default config
	local fname = debug.getinfo(2, "S").source:match("[^@/\\]*.lua$")
	local ok, user_config = pcall(require, "user.configs." .. fname:sub(0, #fname - 4))
	if ok and vim_plugin then
		if user_config == false then
			-- Return early if the user explicitly requires disabling plugin setup
			return
		elseif type(user_config) == "function" then
			-- OK, setup as instructed by the user
			user_config()
		else
			vim.notify(
				string.format(
					"<%s> is not a typical Lua plugin, please return a function with\nthe corresponding options defined instead (usually via `vim.g.*`)",
					plugin_name
				),
				vim.log.levels.ERROR,
				{ title = "[utils] Runtime Error (User Config)" }
			)
		end
	elseif not vim_plugin then
		if user_config == false then
			-- Return early if the user explicitly requires disabling plugin setup
			return
		else
			setup_callback = setup_callback or require(plugin_name).setup
			-- User config exists?
			if ok then
				-- Extend base config if the returned user config is a table
				if type(user_config) == "table" then
					opts = tbl_recursive_merge(opts, user_config)
					setup_callback(opts)
				-- Replace base config if the returned user config is a function
				elseif type(user_config) == "function" then
					local user_opts = user_config(opts)
					if type(user_opts) == "table" then
						setup_callback(user_opts)
					end
				else
					vim.notify(
						string.format(
							[[
Please return a `table` if you want to override some of the default options OR a
`function` returning a `table` if you want to replace the default options completely.

We received a `%s` for plugin <%s>.]],
							type(user_config),
							plugin_name
						),
						vim.log.levels.ERROR,
						{ title = "[utils] Runtime Error (User Config)" }
					)
				end
			else
				-- Nothing provided... Fallback as default setup of the plugin
				setup_callback(opts)
			end
		end
	end
end

return M
