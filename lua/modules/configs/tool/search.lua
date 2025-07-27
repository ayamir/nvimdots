return function()
	local vim_path = require("core.global").vim_path
	local search_backend = require("core.settings").search_backend
	local builtin = require("telescope.builtin")
	local extensions = require("telescope").extensions
	local prompt_pos = require("telescope.config").values.layout_config.horizontal.prompt_position
	local fzf = (search_backend == "fzf") and require("fzf-lua")
	local fzf_opts = { fzf_opts = { ["--layout"] = (prompt_pos == "top" and "reverse" or "default") } }

	local function files()
		local opts = fzf and vim.tbl_deep_extend("force", {}, fzf_opts) or {}
		local cwd = vim.fn.getcwd()
		local is_root = (cwd == vim_path)
		local is_git = (vim.fn.isdirectory(".git") == 1)

		if is_root then
			if fzf then
				return fzf.files(vim.tbl_deep_extend("force", opts, { no_ignore = true }))
			end
			return builtin.find_files(vim.tbl_deep_extend("force", opts, { no_ignore = true }))
		end

		if is_git then
			if fzf then
				return fzf.git_files(opts)
			end
			return builtin.git_files(opts)
		end

		if fzf then
			return fzf.files(opts)
		end
		return builtin.find_files(opts)
	end

	local function oldfiles()
		if fzf then
			local opts = vim.tbl_deep_extend("force", {}, fzf_opts)
			return fzf.oldfiles(opts)
		end
		return builtin.oldfiles()
	end

	local function make_grep(fzf_fn, tb_fn)
		return function()
			local opts = fzf and vim.tbl_deep_extend("force", {}, fzf_opts) or {}
			local cwd = vim.fn.getcwd()
			if cwd == vim_path then
				if fzf then
					opts = vim.tbl_deep_extend("force", opts, { no_ignore = true })
				else
					opts = { additional_args = { "--no-ignore" } }
				end
			end
			if fzf then
				return fzf[fzf_fn](opts)
			end
			return tb_fn(opts)
		end
	end

	local word_in_project = make_grep("live_grep", extensions.live_grep_args.live_grep_args)
	local word_under_cursor = make_grep("grep_cword", builtin.grep_string)

	require("modules.utils").load_plugin("search", {
		prompt_position = prompt_pos,
		collections = {
			-- Search using filenames
			file = {
				initial_tab = 1,
				tabs = {
					{ name = "Files", tele_func = files },
					{
						name = "Frecency",
						tele_func = function()
							extensions.frecency.frecency()
						end,
					},
					{ name = "Oldfiles", tele_func = oldfiles },
					{
						name = "Buffers",
						tele_func = function()
							builtin.buffers()
						end,
					},
				},
			},
			-- Search using patterns
			pattern = {
				initial_tab = 1,
				tabs = {
					{ name = "Word in project", tele_func = word_in_project },
					{ name = "Word under cursor", tele_func = word_under_cursor },
				},
			},
			-- Search Git objects (branches, commits)
			git = {
				initial_tab = 1,
				tabs = {
					{
						name = "Branches",
						tele_func = function()
							builtin.git_branches()
						end,
					},
					{
						name = "Commits",
						tele_func = function()
							builtin.git_commits()
						end,
					},
					{
						name = "Commit content",
						tele_func = function()
							extensions.advanced_git_search.search_log_content()
						end,
					},
					{
						name = "Diff current file with commit",
						tele_func = function()
							extensions.advanced_git_search.diff_commit_file()
						end,
					},
				},
			},
			-- Retrieve dossiers
			dossier = {
				initial_tab = 1,
				tabs = {
					{
						name = "Sessions",
						tele_func = function()
							extensions.persisted.persisted()
						end,
					},
					{
						name = "Projects",
						tele_func = function()
							extensions.projects.projects({})
						end,
					},
					{
						name = "Zoxide",
						tele_func = function()
							extensions.zoxide.list()
						end,
					},
				},
			},
			-- Miscellaneous
			misc = {
				initial_tab = 1,
				tabs = {
					{
						name = "Colorschemes",
						tele_func = function()
							builtin.colorscheme({ enable_preview = true })
						end,
					},
					{
						name = "Notify",
						tele_func = function()
							extensions.notify.notify()
						end,
					},
					{
						name = "Undo History",
						tele_func = function()
							extensions.undo.undo()
						end,
					},
				},
			},
		},
	})
end
