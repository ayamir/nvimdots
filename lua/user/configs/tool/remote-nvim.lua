return function()
	require("remote-nvim").setup({
		-- Configuration for SSH connections
		ssh_config = {
			ssh_binary = "ssh", -- Binary to use for running SSH command
			scp_binary = "scp", -- Binary to use for running SSH copy commands
			ssh_config_file_paths = { "$HOME/.ssh/config" }, -- Which files should be considered to contain the ssh host configurations. NOTE: `Include` is respected in the provided files.
			ssh_prompts = {
				{
					match = "password:",
					type = "secret",
					value_type = "static",
					value = "",
				},
				{
					match = "continue connecting (yes/no/[fingerprint])?",
					type = "plain",
					value_type = "static",
					value = "",
				},
			},
		},

		progress_view = {
			type = "popup",
		},

		offline_mode = {
			enabled = true,
			-- Do not connect to GitHub at all. Not even to get release information.
			no_github = true,
		},

		-- Path to the user's Neovim configuration files. These would be copied to the remote if user chooses to do so.
		neovim_user_config_path = vim.fn.stdpath("config"),

		-- Local client configuration
		local_client_config = {
			-- You can supply your own callback that should be called to create the local client. This is the default implementation.
			-- Two arguments are passed to the callback:
			-- port: Local port at which the remote server is available
			-- workspace_config: Workspace configuration for the host. For all the properties available, see https://github.com/amitds1997/remote-nvim.nvim/blob/main/lua/remote-nvim/providers/provider.lua#L4
			-- A sample implementation using WezTerm tab is at: https://github.com/amitds1997/remote-nvim.nvim/wiki/Configuration-recipes
			callback = function(port, _)
				require("remote-nvim.ui").float_term(
					("nvim --server localhost:%s --remote-ui"):format(port),
					function(exit_code)
						if exit_code ~= 0 then
							vim.notify(
								("Local client failed with exit code %s"):format(exit_code),
								vim.log.levels.ERROR
							)
						end
					end
				)
			end,
		},
	})
end
