return function()
	local dap = require("dap")
	local dapui = require("dapui")
	local mason_dap = require("mason-nvim-dap")

	local icons = { dap = require("modules.utils.icons").get("dap") }
	local colors = require("modules.utils").get_palette()

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.after.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.after.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- We need to override nvim-dap's default highlight groups, AFTER requiring nvim-dap for catppuccin.
	vim.api.nvim_set_hl(0, "DapStopped", { fg = colors.green })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = icons.dap.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = icons.dap.BreakpointCondition, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapStopped", { text = icons.dap.Stopped, texthl = "DapStopped", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = icons.dap.BreakpointRejected, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapLogPoint", { text = icons.dap.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })

	---A handler to setup all clients defined under `tool/dap/clients/*.lua`
	---@param config table
	local function mason_dap_handler(config)
		local dap_name = config.name
		local ok, custom_handler = pcall(require, "tool.dap.clients." .. dap_name)
		if not ok then
			-- Default to use factory config for clients(s) that doesn't include a spec
			mason_dap.default_setup(config)
			return
		elseif type(custom_handler) == "function" then
			-- Case where the protocol requires its own setup
			-- Make sure to set
			-- * dap.adpaters.<dap_name> = { your config }
			-- * dap.configurations.<lang> = { your config }
			-- See `codelldb.lua` for a concrete example.
			custom_handler(config)
		else
			vim.notify(
				string.format(
					"Failed to setup [%s].\n\nClient definition under `tool/dap/clients` must return\na fun(opts) (got '%s' instead)",
					config.name,
					type(custom_handler)
				),
				vim.log.levels.ERROR,
				{ title = "nvim-dap" }
			)
		end
	end

	mason_dap.setup({
		ensure_installed = require("core.settings").dap_deps,
		automatic_installation = true,
		handlers = { mason_dap_handler },
	})
end
