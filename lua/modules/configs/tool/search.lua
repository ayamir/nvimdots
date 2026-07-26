local M = {}

local vim_path = require("core.global").vim_path

local project_patterns = {
	".bzr",
	".csproj",
	".git",
	".github",
	".hg",
	".nvim.lua",
	".pre-commit-config.yaml",
	".pre-commit-config.yml",
	".sln",
	".svn",
	"Makefile",
	"Pipfile",
	"_darcs",
	"package.json",
	"pyproject.toml",
}

local function is_config_dir()
	return vim.uv.cwd() == vim_path
end

local function is_git_dir()
	local stat = vim.uv.fs_stat(".git")
	return stat and stat.type == "directory"
end

local function file_opts(opts)
	return vim.tbl_deep_extend("force", is_config_dir() and { ignored = true, hidden = true } or {}, opts or {})
end

local function grep_opts(opts)
	return vim.tbl_deep_extend("force", is_config_dir() and { ignored = true, hidden = true } or {}, opts or {})
end

local function source_tab(name, source, opts)
	return {
		name = name,
		source = source,
		source_opts = opts,
	}
end

local function dynamic_source_tab(name, source, opts_fn, picker_opts)
	return {
		name = name,
		source = source,
		dynamic_opts = opts_fn,
		picker_opts = picker_opts,
	}
end

local function files_source()
	if is_config_dir() then
		return "files", file_opts()
	elseif is_git_dir() then
		return "git_files", {}
	end
	return "files", {}
end

local function advanced_git_search(method)
	return function(opts)
		return require("modules.utils.advanced_git_search_snacks")[method](opts)
	end
end

local function current_colorscheme_name()
	if require("core.settings").colorscheme == "nvchad" then
		return require("nvconfig").base46.theme
	end
	return vim.g.colors_name
end

local function prefer_current_item(items, current)
	if not current or current == "" then
		return items
	end

	table.sort(items, function(a, b)
		if a.text == current then
			return true
		elseif b.text == current then
			return false
		end
		return a.text < b.text
	end)
	return items
end

local function restore_snacks_colorscheme_preview(picker)
	local state = picker and picker.preview and picker.preview.state
	if not (state and state.colorscheme) then
		return
	end

	pcall(vim.cmd.colorscheme, state.colorscheme)
	if state.background then
		vim.o.background = state.background
	end
	state.colorscheme = nil
end

local function snacks_colorscheme_opts(current)
	local finder = require("snacks.picker.config").finder("vim_colorschemes")
	local items = prefer_current_item(finder({}, {
		filter = { cwd = vim.uv.cwd() },
	}) or {}, current)

	return {
		finder = function()
			return items
		end,
		sort = require("snacks.picker.sort").idx(),
		on_tab_leave = restore_snacks_colorscheme_preview,
	}
end

local function nvchad_theme_opts(current)
	local theme = require("modules.utils.nvchad_theme")
	local original = current
	local confirmed = false
	local items = prefer_current_item(vim.tbl_map(function(name)
		return { text = name }
	end, theme.list()), current)

	return {
		title = "NvChad Base46 Themes",
		finder = function()
			return items
		end,
		format = function(item)
			return { { item.text } }
		end,
		sort = require("snacks.picker.sort").idx(),
		on_change = function(_, item)
			if item then
				theme.apply(item.text, { notify = false })
			end
		end,
		on_tab_leave = function()
			if not confirmed then
				theme.apply(original, { notify = false })
			end
		end,
		on_close = function()
			if not confirmed then
				theme.apply(original, { notify = false })
			end
		end,
		confirm = function(picker, item)
			if item then
				confirmed = true
				theme.apply(item.text, { persist = true })
			end
			picker:close()
		end,
	}
end

local function colorschemes_source()
	local current = current_colorscheme_name()
	if require("core.settings").colorscheme == "nvchad" then
		return "nvimdots_nvchad_themes", nvchad_theme_opts(current)
	end
	return "colorschemes", snacks_colorscheme_opts(current)
end

local function persisted_sessions(opts)
	local persisted = require("persisted")
	local items = vim.tbl_map(function(session)
		local name = vim.fn.fnamemodify(session, ":t:r")
		local dir, branch = unpack(vim.split(name, "@@", { plain = true }))
		dir = (dir or name):gsub("%%", "/")
		if jit.os:find("Windows") then
			dir = dir:gsub("^(%w)/", "%1:/")
		end
		return {
			text = branch and (dir .. " (" .. branch .. ")") or dir,
			file = session,
			session = session,
			dir = dir,
		}
	end, persisted.list())

	return require("snacks").picker.pick(vim.tbl_deep_extend("force", {
		title = "Sessions",
		items = items,
		format = "file",
		confirm = function(picker_obj, item)
			picker_obj:close()
			if item then
				vim.fn.chdir(item.dir)
				persisted.load({ session = item.session })
			end
		end,
	}, opts or {}))
end

function M.options()
	return {
		prompt_position = "top",
		tab_title = { target = "window" },
		picker_opts = {
			auto_close = false,
			layout = { preset = "nvimdots_search" },
		},
		collection_order = { "file", "pattern", "git", "dossier", "misc" },
		collection_labels = {
			file = "Files",
			pattern = "Patterns",
			git = "Git",
			dossier = "Dossiers",
			misc = "Miscellaneous",
		},
		collections = {
			file = {
				initial_tab = 1,
				tabs = {
					{
						name = "Files",
						source = files_source,
						dynamic_opts = function()
							local _, opts = files_source()
							return opts
						end,
					},
					dynamic_source_tab("Frecency", "smart", file_opts),
					source_tab("Oldfiles", "recent"),
					source_tab("Buffers", "buffers"),
				},
			},
			pattern = {
				initial_tab = 1,
				tabs = {
					dynamic_source_tab("Word in project", "grep", grep_opts, { live = true }),
					dynamic_source_tab("Word under cursor", "grep_word", grep_opts, { live = true }),
				},
			},
			git = {
				initial_tab = 1,
				tabs = {
					source_tab("Branches", "git_branches"),
					source_tab("Commits", "git_log"),
					{
						name = "Commit content",
						picker = advanced_git_search("search_log_content"),
						picker_opts = { live = true },
					},
					{
						name = "Diff current file",
						picker = advanced_git_search("diff_commit_file"),
						picker_opts = { live = true },
					},
				},
			},
			dossier = {
				initial_tab = 1,
				tabs = {
					{ name = "Sessions", picker = persisted_sessions },
					source_tab("Projects", "projects", { patterns = project_patterns }),
					source_tab("Zoxide", "zoxide"),
				},
			},
			misc = {
				initial_tab = 1,
				tabs = {
					{ name = "Colorschemes", source = colorschemes_source },
					source_tab("Notify", "notifications"),
					source_tab("Undo History", "undo"),
				},
			},
		},
	}
end

return M
