local settings = {}
local home = require("core.global").home

settings["use_ssh"] = true

settings["format_on_save"] = true

settings["format_disabled_dirs"] = {
	home .. "/format_disabled_dir_under_home",
}

-- Disable features that could affect performance when loading large files
settings["load_big_files_faster"] = true

---Change the colors of the global palette here.
---Settings will complete their replacement at initialization.
---Parameters will be automatically completed as you type.
---Example: { sky = "#04A5E5" }
---@type palette
settings["palette_overwrite"] = {}

-- Set the colorscheme to use here.
-- Available values are: `catppuccin`, `edge`, `nord`.
settings["colorscheme"] = "catppuccin"

-- Set background color to use here.
-- Useful for when you want to use a colorscheme that has a light and dark variant like `edge`.
-- Available values are: `dark`, `light`.
settings["background"] = "dark"

return settings
