local settings = {}
local home = require("core.global").home

-- Set it to false if you want to use https to update plugins and treesitter parsers.
settings["use_ssh"] = true

-- Set it to false if there are no need to format on save.
settings["format_on_save"] = true

-- Set the format disabled directories here, files under these dirs won't be formatted on save.
settings["format_disabled_dirs"] = {
	home .. "/format_disabled_dir_under_home",
}

-- Set it to false if you don't use nvim to open big files.
settings["load_big_files_faster"] = true

---Change the colors of the global palette here.
---Settings will complete their replacement at initialization.
---Parameters will be automatically completed as you type.
---Example: { sky = "#04A5E5" }
---@type palette
settings["palette_overwrite"] = {}

-- Set the colorscheme to use here.
-- Available values are: `catppuccin`, `catppuccin-latte`, `catppucin-mocha`, `catppuccin-frappe`, `catppuccin-macchiato`, `edge`, `nord`.
settings["colorscheme"] = "catppuccin"

-- Set background color to use here.
-- Useful for when you want to use a colorscheme that has a light and dark variant like `edge`.
-- Available values are: `dark`, `light`.
settings["background"] = "dark"

return settings
