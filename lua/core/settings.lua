local settings = {}

-- Set to false if you want to use HTTPS to update plugins and Treesitter parsers.
---@type boolean
settings["use_ssh"] = true

-- Set to false if you don't use Copilot.
---@type boolean
settings["use_copilot"] = true

-- Set to false if you don't want to format on save.
---@type boolean
settings["format_on_save"] = true

-- Format timeout in milliseconds.
---@type number
settings["format_timeout"] = 1000

-- Set to false to disable format notification.
---@type boolean
settings["format_notify"] = true

-- Set to true if you want to format ONLY the *changed lines* as defined by your version control system.
-- NOTE: This will only be respected if:
--  > The buffer is under version control (Git or Mercurial);
--  > Any server attached to the buffer supports the |DocumentRangeFormattingProvider| capability.
-- Otherwise, Neovim will fall back to formatting the whole buffer and issue a warning.
---@type boolean
settings["format_modifications_only"] = false

-- Filetypes in this list will skip LSP formatting if the value is true.
---@type table<string, boolean>
settings["formatter_block_list"] = {
	-- Example
	lua = false,
}

-- Servers in this list will skip formatting capabilities if the value is true.
---@type table<string, boolean>
settings["server_formatting_block_list"] = {
	clangd = true,
	lua_ls = true,
	ts_ls = true,
}

-- Directories where formatting on save is disabled.
-- NOTE: Strings may contain regular expressions (vim regex). |regexp|
-- NOTE: Directories are automatically normalized using |vim.fs.normalize()|.
---@type string[]
settings["format_disabled_dirs"] = {
	-- Example
	"~/format_disabled_dir",
}

-- Set to false to disable diagnostic virtual lines.
-- If disabled, use trouble.nvim to view diagnostics (press `<leader>ld` to toggle).
---@type boolean
settings["diagnostics_virtual_lines"] = false

-- Set the minimum severity level of diagnostics to display.
-- Priority: `Error` > `Warning` > `Information` > `Hint`.
-- For example, if set to `Warning`, only warnings and errors will be shown.
-- NOTE: This only works when `diagnostics_virtual_text` is true.
---@type "ERROR"|"WARN"|"INFO"|"HINT"
settings["diagnostics_level"] = "HINT"

-- List plugins to disable here (e.g., "Some-User/A-Repo").
---@type string[]
settings["disabled_plugins"] = {}

-- Set to false if you don't use Neovim to open large files.
---@type boolean
settings["load_big_files_faster"] = true

-- Customize the global color palette here.
-- These settings will override the defaults during initialization.
-- Parameters will auto-complete as you type.
-- Example: { sky = "#04A5E5" }
---@type palette[]
settings["palette_overwrite"] = {}

-- Set the colorscheme here.
-- Valid options: `catppuccin`, `catppuccin-latte`, `catppuccin-mocha`, `catppuccin-frappe`, `catppuccin-macchiato`.
---@type string
settings["colorscheme"] = "catppuccin"

-- Set to true if your terminal supports a transparent background.
---@type boolean
settings["transparent_background"] = false

-- Set the background mode here.
-- Useful for themes with both light and dark variants.
-- Valid values: `dark`, `light`.
---@type "dark"|"light"
settings["background"] = "dark"

-- Set the command for opening external URLs.
-- This is ignored on Windows and macOS, which use built-in handlers.
---@type string
settings["external_browser"] = "chrome-cli open"

-- Set the search backend here.
-- `telescope` is sufficient for most use cases.
-- `fzf` is faster for large repositories but requires the fzf binary.
---@type "telescope"|"fzf"
settings["search_backend"] = "telescope"

-- Set to false to disable LSP inlay hints.
---@type boolean
settings["lsp_inlayhints"] = false

-- LSPs to install during bootstrap.
-- Full list: https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
---@type string[]
settings["lsp_deps"] = {
	"bashls",
	"clangd",
	"html",
	"jsonls",
	"lua_ls",
	"pylsp",
	"gopls",
}

-- General-purpose sources for none-ls to install during bootstrap.
-- Supported sources: https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins
---@type string[]
settings["null_ls_deps"] = {
	"clang_format",
	"gofumpt",
	"goimports",
	"prettier",
	"shfmt",
	"stylua",
	"vint",
}

-- Debug Adapter Protocol (DAP) clients to install and configure during bootstrap.
-- Supported DAPs: https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
---@type string[]
settings["dap_deps"] = {
	"codelldb", -- C-Family
	"delve", -- Go
	"python", -- Python (debugpy)
}

-- Treesitter parsers to install during bootstrap.
-- Full list: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
---@type string[]
settings["treesitter_deps"] = {
	"bash",
	"c",
	"cpp",
	"css",
	"go",
	"gomod",
	"html",
	"javascript",
	"json",
	"jsonc",
	"latex",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"typescript",
	"vimdoc",
	"vue",
	"yaml",
}

-- GUI settings for clients like `neovide` or `neovim-qt`.
-- NOTE: Only the following GUI options are supported; others will be ignored.
---@type { font_name: string, font_size: number }
settings["gui_config"] = {
	font_name = "JetBrainsMono Nerd Font",
	font_size = 12,
}

-- Specific settings for `neovide`.
-- Remove the `neovide_` prefix (with trailing underscore) from all entries below.
-- Supported entries: https://neovide.dev/configuration.html
---@type table<string, boolean|number|string>
settings["neovide_config"] = {
	no_idle = false,
	input_ime = true,
	fullscreen = true,
	padding_left = 8,
	confirm_quit = true,
	cursor_vfx_mode = "torpedo",
	cursor_trail_size = 0.05,
	cursor_antialiasing = true,
	hide_mouse_when_typing = true,
	input_macos_alt_is_meta = false,
	cursor_animation_length = 0.03,
	cursor_vfx_particle_speed = 20.0,
	cursor_vfx_particle_density = 5.0,
}

-- Set the dashboard startup image here.
-- Generate ASCII art with: https://github.com/TheZoraiz/ascii-image-converter
-- More info: https://github.com/ayamir/nvimdots/wiki/Issues#change-dashboard-startup-image
---@type string[]
settings["dashboard_image"] = {
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣾⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣟⠻⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⡿⢫⣷⣿⣿⣿⣿⣿⣿⣿⣾⣯⣿⡿⢧⡚⢷⣌⣽⣿⣿⣿⣿⣿⣶⡌⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣇⣘⠿⢹⣿⣿⣿⣿⣿⣻⢿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣻⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⡇⠀⣬⠏⣿⡇⢻⣿⣿⣿⣿⣿⣿⣿⣷⣼⣿⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⠀⠈⠁⠀⣿⡇⠘⡟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣇⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⡏⠀⠀⠐⠀⢻⣇⠀⠀⠹⣿⣿⣿⣿⣿⣿⣩⡶⠼⠟⠻⠞⣿⡈⠻⣟⢻⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢿⠀⡆⠀⠘⢿⢻⡿⣿⣧⣷⢣⣶⡃⢀⣾⡆⡋⣧⠙⢿⣿⣿⣟⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⡥⠂⡐⠀⠁⠑⣾⣿⣿⣾⣿⣿⣿⡿⣷⣷⣿⣧⣾⣿⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⡿⣿⣍⡴⠆⠀⠀⠀⠀⠀⠀⠀⠀⣼⣄⣀⣷⡄⣙⢿⣿⣿⣿⣿⣯⣶⣿⣿⢟⣾⣿⣿⢡⣿⣿⣿⣿⣿]],
	[[⣿⡏⣾⣿⣿⣿⣷⣦⠀⠀⠀⢀⡀⠀⠀⠠⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣡⣾⣿⣿⢏⣾⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⣿⣿⣿⣿⣿⡴⠀⠀⠀⠀⠀⠠⠀⠰⣿⣿⣿⣷⣿⠿⠿⣿⣿⣭⡶⣫⠔⢻⢿⢇⣾⣿⣿⣿⣿⣿⣿]],
	[[⣿⣿⣿⡿⢫⣽⠟⣋⠀⠀⠀⠀⣶⣦⠀⠀⠀⠈⠻⣿⣿⣿⣾⣿⣿⣿⣿⡿⣣⣿⣿⢸⣾⣿⣿⣿⣿⣿⣿⣿]],
	[[⡿⠛⣹⣶⣶⣶⣾⣿⣷⣦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⡿⠫⠾⠿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⡆⣠⢀⣴⣏⡀⠀⠀⠀⠉⠀⠀⢀⣠⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣯⣟⠷⢷⣿⡿⠋⠀⠀⠀⠀⣵⡀⢠⡿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
	[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⢿⣿⣿⠂⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣍⠛⠿⣿⣿⣿⣿⣿⣿]],
}

return require("modules.utils").extend_config(settings, "user.settings")
