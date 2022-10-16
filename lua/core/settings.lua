local settings = {}
local home = os.getenv("HOME")

settings["use_ssh"] = true
settings["format_disabled_dirs"] = {
	home .. "/.config/nvim",
}

return settings
