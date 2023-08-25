local M = {}

M.setup = function()
	local is_windows = require("core.global").is_windows

	local mason_registry = require("mason-registry")
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local icons = {
		ui = require("modules.utils.icons").get("ui", true),
		misc = require("modules.utils.icons").get("misc", true),
	}

	require("modules.utils").load_plugin("mason", {
		ui = {
			border = "single",
			icons = {
				package_pending = icons.ui.Modified_alt,
				package_installed = icons.ui.Check,
				package_uninstalled = icons.misc.Ghost,
			},
			keymaps = {
				toggle_server_expand = "<CR>",
				install_server = "i",
				update_server = "u",
				check_server_version = "c",
				update_all_servers = "U",
				check_outdated_servers = "C",
				uninstall_server = "X",
				cancel_installation = "<C-c>",
			},
		},
	})

	-- Additional plugins for pylsp
	mason_registry:on(
		"package:install:success",
		vim.schedule_wrap(function(pkg)
			if pkg.name ~= "python-lsp-server" then
				return
			end

			local venv = vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server/venv"
			local python = is_windows and venv .. "/Scripts/python.exe" or venv .. "/bin/python"
			local black = is_windows and venv .. "/Scripts/black.exe" or venv .. "/bin/black"
			local ruff = is_windows and venv .. "/Scripts/ruff.exe" or venv .. "/bin/ruff"

			require("plenary.job")
				:new({
					command = python,
					args = {
						"-m",
						"pip",
						"install",
						"-U",
						"--disable-pip-version-check",
						"python-lsp-black",
						"python-lsp-ruff",
						"pylsp-rope",
					},
					cwd = venv,
					env = { VIRTUAL_ENV = venv },
					on_exit = function()
						if vim.fn.executable(black) == 1 and vim.fn.executable(ruff) == 1 then
							vim.notify(
								"Finished installing pylsp plugins",
								vim.log.levels.INFO,
								{ title = "[lsp] Install Status" }
							)
						else
							vim.notify(
								"Failed to install pylsp plugins. [Executable not found]",
								vim.log.levels.ERROR,
								{ title = "[lsp] Install Failure" }
							)
						end
					end,
					on_start = function()
						vim.notify(
							"Now installing pylsp plugins...",
							vim.log.levels.INFO,
							{ title = "[lsp] Install Status", timeout = 6000 }
						)
					end,
					on_stderr = function(_, msg_stream)
						vim.notify(msg_stream, vim.log.levels.ERROR, { title = "[lsp] Install Failure" })
					end,
				})
				:start()
		end)
	)
end

return M
