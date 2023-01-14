local settings = {}
local home = os.getenv("HOME")

settings["use_ssh"] = true

settings["format_on_save"] = true

settings["format_disabled_dirs"] = {
	home .. "/format_disabled_dir_under_home",
}

---Change the colors of the global palette here.
---Settings will complete their replacement at initialization.
---Parameters will be automatically completed as you type.
---Example: { sky = "#04A5E5" }
---@type palette
settings["palette_overwrite"] = {}

return settings
