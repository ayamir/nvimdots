local formatting = require("modules.completion.formatting")

local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

require("lspconfig.ui.windows").default_options.border = "single"

local icons = {
	ui = require("modules.ui.icons").get("ui", true),
	misc = require("modules.ui.icons").get("misc", true),
}

mason.setup({
	ui = {
		border = "rounded",
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
mason_lspconfig.setup({
	ensure_installed = {
		"bashls",
		"clangd",
		"efm",
		"gopls",
		"pyright",
		"sumneko_lua",
	},
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local opts = {
	on_attach = function(client, bufnr)
		require("lsp_signature").on_attach({
			bind = true,
			use_lspsaga = false,
			floating_window = true,
			fix_pos = true,
			hint_enable = true,
			hi_parameter = "Search",
			handler_opts = {
				border = "rounded",
			},
		})
	end,
	capabilities = capabilities,
}

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = opts.capabilities,
			on_attach = opts.on_attach,
		})
	end,

	["bashls"] = function()
		local bashls_opts = require("modules.completion.server-settings.bashls")
		local extra_opts = vim.tbl_deep_extend("keep", bashls_opts, opts)
		lspconfig.bashls.setup(extra_opts)
	end,

	["clangd"] = function()
		local clangd_capabilities = capabilities
		clangd_capabilities.offsetEncoding = { "utf-16", "utf-8" }
		local clangd_opts = require("modules.completion.server-settings.clangd")
		local extra_opts =
			vim.tbl_deep_extend("keep", clangd_opts, { on_attach = opts.on_attach, capabilities = clangd_capabilities })
		lspconfig.clangd.setup(extra_opts)
	end,

	["efm"] = function()
		lspconfig.efm.setup(opts)
	end,

	["gopls"] = function()
		local gopls_opts = require("modules.completion.server-settings.gopls")
		local extra_opts = vim.tbl_deep_extend("keep", gopls_opts, opts)
		lspconfig.gopls.setup(extra_opts)
	end,

	["jsonls"] = function()
		local jsonls_opts = require("modules.completion.server-settings.jsonls")
		local extra_opts = vim.tbl_deep_extend("keep", jsonls_opts, opts)
		lspconfig.jsonls.setup(extra_opts)
	end,

	["sumneko_lua"] = function()
		local sumneko_opts = require("modules.completion.server-settings.sumneko_lua")
		local extra_opts = vim.tbl_deep_extend("keep", sumneko_opts, opts)
		lspconfig.sumneko_lua.setup(extra_opts)
	end,
})

local function html_lsp_setup()
	local html_opts = require("modules.completion.server-settings.html")
	local extra_opts = vim.tbl_deep_extend("keep", html_opts, opts)
	lspconfig.html.setup({ extra_opts })
end
html_lsp_setup()

local efmls = require("efmls-configs")

-- Init `efm-langserver` here.

efmls.init({
	on_attach = opts.on_attach,
	capabilities = capabilities,
	init_options = { documentFormatting = true, codeAction = true },
})

-- Require `efmls-configs-nvim`'s config here

local vint = require("efmls-configs.linters.vint")
local eslint = require("efmls-configs.linters.eslint")
local flake8 = require("efmls-configs.linters.flake8")
local shellcheck = require("efmls-configs.linters.shellcheck")

local black = require("efmls-configs.formatters.black")
local stylua = require("efmls-configs.formatters.stylua")
local prettier = require("efmls-configs.formatters.prettier")
local shfmt = require("efmls-configs.formatters.shfmt")

-- Add your own config for formatter and linter here

-- local rustfmt = require("modules.completion.efm.formatters.rustfmt")
local clangfmt = require("modules.completion.efm.formatters.clangfmt")

-- Override default config here

flake8 = vim.tbl_extend("force", flake8, {
	prefix = "flake8: max-line-length=160, ignore F403 and F405",
	lintStdin = true,
	lintIgnoreExitCode = true,
	lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
	lintCommand = "flake8 --max-line-length 160 --extend-ignore F403,F405 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
})

-- Setup formatter and linter for efmls here

efmls.setup({
	vim = { formatter = vint },
	lua = { formatter = stylua },
	c = { formatter = clangfmt },
	cpp = { formatter = clangfmt },
	python = { formatter = black },
	vue = { formatter = prettier },
	typescript = { formatter = prettier, linter = eslint },
	javascript = { formatter = prettier, linter = eslint },
	typescriptreact = { formatter = prettier, linter = eslint },
	javascriptreact = { formatter = prettier, linter = eslint },
	yaml = { formatter = prettier },
	html = { formatter = prettier },
	css = { formatter = prettier },
	scss = { formatter = prettier },
	sh = { formatter = shfmt, linter = shellcheck },
	markdown = { formatter = prettier },
	-- rust = {formatter = rustfmt},
})

formatting.configure_format_on_save()
