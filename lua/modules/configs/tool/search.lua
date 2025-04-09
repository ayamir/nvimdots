return function()
	local builtin = require("telescope.builtin")
	local extensions = require("telescope").extensions
	local vim_path = require("core.global").vim_path

	require("modules.utils").load_plugin("search", {
		collections = {
			-- Search using filenames
			file = {
				initial_tab = 1,
				tabs = {
					{
						name = "Files",
						tele_func = function(opts)
							opts = opts or {}
							if vim.fn.getcwd() == vim_path then
								builtin.find_files(vim.tbl_deep_extend("force", opts, { no_ignore = true }))
							elseif vim.fn.isdirectory(".git") == 1 then
								builtin.git_files(opts)
							else
								builtin.find_files(opts)
							end
						end,
					},
					{
						name = "Frecency",
						tele_func = function()
							extensions.frecency.frecency()
						end,
					},
					{
						name = "Oldfiles",
						tele_func = function()
							builtin.oldfiles()
						end,
					},
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
					{
						name = "Word in project",
						tele_func = function()
							local opts = {}
							if vim.fn.getcwd() == vim_path then
								opts["additional_args"] = { "--no-ignore" }
							end
							extensions.live_grep_args.live_grep_args(opts)
						end,
					},
					{
						name = "Word under cursor",
						tele_func = function(opts)
							opts = opts or {}
							if vim.fn.getcwd() == vim_path then
								opts["additional_args"] = { "--no-ignore" }
							end
							builtin.grep_string(opts)
						end,
					},
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

	vim.api.nvim_create_user_command("TelescopeFiles", function()
		require("search").open({ collection = "file" })
	end, { nargs = 0 })

	vim.api.nvim_create_user_command("TelescopePatterns", function()
		require("search").open({ collection = "pattern" })
	end, { nargs = 0 })

	vim.api.nvim_create_user_command("TelescopeGit", function()
		require("search").open({ collection = "git" })
	end, { nargs = 0 })

	vim.api.nvim_create_user_command("TelescopeDossier", function()
		require("search").open({ collection = "dossier" })
	end, { nargs = 0 })

	vim.api.nvim_create_user_command("TelescopeMisc", function()
		require("search").open({ collection = "misc" })
	end, { nargs = 0 })
end
