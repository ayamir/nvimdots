return function()
	local vim_path = require("core.global").vim_path
	local search_backend = require("core.settings").search_backend
	local use_fzf = search_backend == "fzf"
	local fzf = use_fzf and require("fzf-lua")
	local extensions = require("telescope").extensions
	local builtins = require("telescope.builtin")
	local prompt_pos = require("telescope.config").values.layout_config.horizontal.prompt_position

	local base_opts = use_fzf and { fzf_opts = { ["--layout"] = (prompt_pos == "top" and "reverse" or "default") } }
		or {}

	---Returns current directory and whether it's a Git repo root
	---@return string @Current working directory
	---@return boolean|nil @true if `.git` folder exists here, false if `.git` exists but isn't folder, nil if `.git` missing
	local function get_root_info()
		local cwd = vim.uv.cwd()
		local stat = vim.uv.fs_stat(".git")
		return cwd, stat and stat.type == "directory"
	end

	---Creates a file search function based on backend and context
	---@param fzf_fn string @Name of the fzf-lua function to call (e.g. "files")
	---@param tb_fn function @Telescope builtin function to call (e.g. `builtin.find_files`)
	---@param git_only boolean @Whether to restrict search to git tracked files only
	---@return fun():any @A function that executes the selected search with proper options
	local function file_searcher(fzf_fn, tb_fn, git_only)
		return function()
			local cwd, is_git = get_root_info()
			local opts = vim.deepcopy(base_opts, true)
			if cwd == vim_path then
				opts.no_ignore = true
				return (use_fzf and fzf[fzf_fn] or tb_fn)(opts)
			elseif git_only and is_git then
				return (use_fzf and fzf.git_files or builtins.git_files)(opts)
			elseif not git_only then
				return (use_fzf and fzf[fzf_fn] or tb_fn)(opts)
			else
				-- fallback
				return (use_fzf and fzf.files or builtins.find_files)(opts)
			end
		end
	end

	---Creates a function that performs a live grep search using the appropriate backend
	---@param fzf_fn string @Name of the fzf-lua grep function to call (e.g. "live_grep")
	---@param tb_fn function @Telescope builtin grep function (e.g. `builtin.grep_string`)
	---@return fun():any @Function that runs the selected grep with proper options
	local function grep_searcher(fzf_fn, tb_fn)
		return function()
			local cwd = vim.uv.cwd()
			local opts = vim.deepcopy(base_opts, true)
			if cwd == vim_path then
				if use_fzf then
					opts.no_ignore = true
				else
					opts = { additional_args = { "--no-ignore" } }
				end
			end
			return use_fzf and fzf[fzf_fn](opts) or tb_fn(opts)
		end
	end

	-- Tables of pickers
	local pickers = {
		file = {
			{ "Files", file_searcher("files", builtins.find_files, false) },
			{
				"Frecency",
				function()
					extensions.frecency.frecency()
				end,
			},
			{ "Oldfiles", use_fzf and function()
				fzf.oldfiles(base_opts)
			end or builtins.oldfiles },
			{ "Buffers", builtins.buffers },
		},
		pattern = {
			{ "Word in project", grep_searcher("live_grep", extensions.live_grep_args.live_grep_args) },
			{ "Word under cursor", grep_searcher("grep_cword", builtins.grep_string) },
		},
		git = {
			{ "Branches", builtins.git_branches },
			{ "Commits", builtins.git_commits },
			{ "Commit content", extensions.advanced_git_search.search_log_content },
			{ "Diff current file", extensions.advanced_git_search.diff_commit_file },
		},
		dossier = {
			{ "Sessions", extensions.persisted.persisted },
			{
				"Projects",
				function()
					extensions.projects.projects()
				end,
			},
			{ "Zoxide", extensions.zoxide.list },
		},
		misc = {
			{
				"Colorschemes",
				function()
					builtins.colorscheme({ enable_preview = true })
				end,
			},
			{ "Notify", extensions.notify.notify },
			{ "Undo History", extensions.undo.undo },
		},
	}

	-- Build collections
	local collections = {}
	for kind, list in pairs(pickers) do
		local init = { initial_tab = 1, tabs = {} }
		for _, entry in ipairs(list) do
			table.insert(init.tabs, { name = entry[1], tele_func = entry[2] })
		end
		collections[kind] = init
	end

	require("modules.utils").load_plugin("search", {
		prompt_position = prompt_pos,
		collections = collections,
	})
end
