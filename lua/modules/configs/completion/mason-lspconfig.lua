local M = {}

M.setup = function()
	local is_windows = require("core.global").is_windows

	local lsp_deps = require("core.settings").lsp_deps
	local mason_registry = require("mason-registry")
	local mason_lspconfig = require("mason-lspconfig")

	require("lspconfig.ui.windows").default_options.border = "rounded"
	require("modules.utils").load_plugin("mason-lspconfig", {
		ensure_installed = lsp_deps,
		-- Skip auto enable because we are loading language servers lazily
		automatic_enable = false,
	})

	vim.diagnostic.config({
		signs = true,
		underline = true,
		virtual_text = false,
		update_in_insert = false,
	})

	local opts = {
		capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		),
	}
	---A handler to setup all servers defined under `completion/servers/*.lua`
	---@param lsp_name string
	local function mason_lsp_handler(lsp_name)
		-- rust_analyzer is configured using mrcjkb/rustaceanvim
		-- warn users if they have set it up manually
		if lsp_name == "rust_analyzer" then
			local config_exist = pcall(require, "completion.servers." .. lsp_name)
			if config_exist then
				vim.notify(
					[[
`rust_analyzer` is configured independently via `mrcjkb/rustaceanvim`. To get rid of this warning,
please REMOVE your LSP configuration (rust_analyzer.lua) from the `servers` directory and configure
`rust_analyzer` using the appropriate init options provided by `rustaceanvim` instead.]],
					vim.log.levels.WARN,
					{ title = "nvim-lspconfig" }
				)
			end
			return
		end

		local ok, custom_handler = pcall(require, "user.configs.lsp-servers." .. lsp_name)
		local default_ok, default_handler = pcall(require, "completion.servers." .. lsp_name)
		-- Use preset if there is no user definition
		if not ok then
			ok, custom_handler = default_ok, default_handler
		end

		if not ok then
			-- Default to use factory config for server(s) that doesn't include a spec
			require("modules.utils").register_server(lsp_name, opts)
		elseif type(custom_handler) == "function" then
			-- Case where language server requires its own setup
			-- Be sure to call `vim.lsp.config()` within the setup function.
			-- Refer to |vim.lsp.config()| for documentation.
			-- For an example, see `clangd.lua`.
			custom_handler(opts)
			vim.lsp.enable(lsp_name)
		elseif type(custom_handler) == "table" then
			require("modules.utils").register_server(
				lsp_name,
				vim.tbl_deep_extend(
					"force",
					opts,
					type(default_handler) == "table" and default_handler or {},
					custom_handler
				)
			)
		else
			vim.notify(
				string.format(
					"Failed to setup [%s].\n\nServer definition under `completion/servers` must return\neither a fun(opts) or a table (got '%s' instead)",
					lsp_name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-lspconfig" }
			)
		end
	end

	---A simplified mimic of <mason-lspconfig 1.x>'s `setup_handlers` callback.
	---Invoked for each Mason package (name or `Package` object) to configure its language server.
	---@param pkg string|{name: string} Either the package name (string) or a Package object
	local function setup_lsp_for_package(pkg)
		-- First try to grab the builtin mappings
		local mappings = mason_lspconfig.get_mappings().package_to_lspconfig
		-- If empty or nil, build it by hand
		if not mappings or vim.tbl_isempty(mappings) then
			mappings = {}
			for _, spec in ipairs(mason_registry.get_all_package_specs()) do
				local lspconfig = vim.tbl_get(spec, "neovim", "lspconfig")
				if lspconfig then
					mappings[spec.name] = lspconfig
				end
			end
		end

		-- Figure out the package name and lookup
		local name = type(pkg) == "string" and pkg or pkg.name
		local srv = mappings[name]
		if not srv then
			return
		end

		-- Invoke the handler
		mason_lsp_handler(srv)
	end

	for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
		setup_lsp_for_package(pkg)
	end

	-- Hook into Mason's package install event to install extra plugins for pylsp (black, ruff, rope),
	-- then configure the installed package's LSP using setup_lsp_for_package.
	mason_registry:on(
		"package:install:success",
		vim.schedule_wrap(function(pkg)
			if pkg.name == "python-lsp-server" then
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
							if msg_stream then
								vim.notify(msg_stream, vim.log.levels.ERROR, { title = "[lsp] Install Failure" })
							end
						end,
					})
					:start()
			end

			setup_lsp_for_package(pkg)
		end)
	)
end

return M
