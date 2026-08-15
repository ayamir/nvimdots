local M = {}

local function user_settings_path()
	return vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "user", "settings.lua")
end

local function quoted(value)
	return string.format("%q", value)
end

local function brace_delta(line)
	local code = line:gsub("%-%-.*$", "")
	local _, opens = code:gsub("{", "")
	local _, closes = code:gsub("}", "")
	return opens - closes
end

local function find_nvchad_settings(lines)
	for index, line in ipairs(lines) do
		if line:match([[settings%[%s*["']nvchad["']%s*%]%s*=%s*{]]) or line:match([[settings%.nvchad%s*=%s*{]]) then
			local depth = 0
			for cursor = index, #lines do
				depth = depth + brace_delta(lines[cursor])
				if depth <= 0 then
					return index, cursor
				end
			end

			return index, #lines
		end
	end
end

local function update_existing_nvchad_theme(lines, theme)
	local start_line, end_line = find_nvchad_settings(lines)
	if not start_line then
		return false
	end

	local depth = brace_delta(lines[start_line])
	for index = start_line + 1, end_line - 1 do
		if depth == 1 and lines[index]:match("^%s*theme%s*=") then
			local indent = lines[index]:match("^(%s*)") or ""
			lines[index] = indent .. "theme = " .. quoted(theme) .. ","
			return true
		end

		depth = depth + brace_delta(lines[index])
	end

	table.insert(lines, start_line + 1, "\ttheme = " .. quoted(theme) .. ",")
	return true
end

local function append_nvchad_theme_override(lines, theme)
	local insert_at = #lines + 1
	for index = #lines, 1, -1 do
		if lines[index]:match("^%s*return%s+settings%s*$") then
			insert_at = index
			break
		end
	end

	local block = {
		"",
		[[settings["nvchad"] = vim.tbl_deep_extend("force", settings["nvchad"] or {}, {]],
		"\ttheme = " .. quoted(theme) .. ",",
		"})",
	}

	for offset, line in ipairs(block) do
		table.insert(lines, insert_at + offset - 1, line)
	end
end

function M.persist(theme, opts)
	opts = opts or {}
	local path = opts.path or user_settings_path()
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		lines = { "local settings = {}", "", "return settings" }
	end

	if not update_existing_nvchad_theme(lines, theme) then
		append_nvchad_theme_override(lines, theme)
	end

	local write_ok, err = pcall(vim.fn.writefile, lines, path)
	if not write_ok then
		vim.notify("Failed to write NvChad theme to " .. path .. ": " .. tostring(err), vim.log.levels.ERROR)
		return false
	end

	return true
end

function M.list()
	local ok, utils = pcall(require, "nvchad.utils")
	if ok and type(utils.list_themes) == "function" then
		return utils.list_themes()
	end

	return {}
end

function M.apply(theme, opts)
	opts = opts or {}
	if not theme or theme == "" then
		return false
	end

	local config = require("nvconfig").base46
	config.theme = theme

	local settings = require("core.settings")
	settings.nvchad = settings.nvchad or {}
	settings.nvchad.theme = theme

	local ok, base46 = pcall(require, "base46")
	if not ok then
		vim.notify("NvChad Base46 is not available", vim.log.levels.ERROR)
		return false
	end

	base46.load_all_highlights()
	pcall(vim.cmd.redrawstatus)
	pcall(vim.cmd.redrawtabline)

	if opts.persist then
		if not M.persist(theme) then
			return false
		end
	end

	if opts.notify ~= false then
		vim.notify("NvChad theme: " .. theme, vim.log.levels.INFO)
	end

	return true
end

function M.toggle()
	local config = require("nvconfig").base46
	local themes = config.theme_toggle or {}
	if config.theme ~= themes[1] and config.theme ~= themes[2] then
		vim.notify("Set current NvChad theme to one of the configured toggle themes", vim.log.levels.WARN)
		return
	end

	vim.g.icon_toggled = not vim.g.icon_toggled
	vim.g.toggle_theme_icon = vim.g.icon_toggled and "   " or "   "

	M.apply(config.theme == themes[1] and themes[2] or themes[1], { persist = true })
end

function M.toggle_transparency()
	local config = require("nvconfig").base46
	config.transparency = not config.transparency
	require("base46").load_all_highlights()
	pcall(vim.cmd.redrawstatus)
	pcall(vim.cmd.redrawtabline)
end

function M.picker(opts)
	opts = opts or {}
	local original = opts.initial_theme or require("nvconfig").base46.theme
	opts.initial_theme = nil
	local confirmed = false
	local user_confirm = opts.confirm
	local user_on_change = opts.on_change
	local user_on_close = opts.on_close

	local function preview(theme)
		if theme then
			M.apply(theme, { notify = false })
		end
	end

	local items = vim.tbl_map(function(theme)
		return { text = theme }
	end, M.list())
	table.sort(items, function(a, b)
		if a.text == original then
			return true
		elseif b.text == original then
			return false
		end
		return a.text < b.text
	end)

	return require("snacks").picker.pick(vim.tbl_extend("force", opts, {
		title = opts.title or opts.prompt_title or "NvChad Base46 Themes",
		items = items,
		format = function(item)
			return { { item.text } }
		end,
		layout = opts.layout or {
			preview = false,
			preset = "select",
		},
		on_change = function(picker, item)
			if item then
				preview(item.text)
			end
			if user_on_change then
				user_on_change(picker, item)
			end
		end,
		on_close = function(picker)
			if not confirmed then
				M.apply(original, { notify = false })
			end
			if user_on_close then
				user_on_close(picker)
			end
		end,
		confirm = function(picker, item, action)
			if item then
				confirmed = true
				M.apply(item.text, { persist = true })
			end
			if user_confirm then
				user_confirm(picker, item, action)
				return
			end
			picker:close()
		end,
	}))
end

function M.tabufline_btns()
	local btn = require("nvchad.tabufline.utils").btn
	local toggle_theme = btn(vim.g.toggle_theme_icon or "   ", "ThemeToggleBtn", "NvimdotsToggle_theme")
	local close_all_bufs = btn(" 󰅖 ", "CloseAllBufsBtn", "CloseAllBufs")
	return toggle_theme .. close_all_bufs
end

function M.setup()
	pcall(vim.api.nvim_del_user_command, "NvChadThemePicker")
	vim.api.nvim_create_user_command("NvChadThemePicker", function()
		M.picker()
	end, { desc = "Pick NvChad Base46 theme" })

	pcall(vim.api.nvim_del_user_command, "NvChadThemeToggle")
	vim.api.nvim_create_user_command("NvChadThemeToggle", function()
		M.toggle()
	end, { desc = "Toggle NvChad Base46 theme" })

	pcall(vim.api.nvim_del_user_command, "NvChadTransparencyToggle")
	vim.api.nvim_create_user_command("NvChadTransparencyToggle", function()
		M.toggle_transparency()
	end, { desc = "Toggle NvChad Base46 transparency" })

	vim.cmd([[
function! TbNvimdotsToggle_theme(a,b,c,d)
	lua require("modules.utils.nvchad_theme").toggle()
endfunction
]])

	local ok, base46 = pcall(require, "base46")
	if ok then
		base46.toggle_theme = M.toggle
		base46.toggle_transparency = M.toggle_transparency
	end
end

return M
