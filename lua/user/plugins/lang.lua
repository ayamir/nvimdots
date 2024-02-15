local custom = {}

custom["epwalsh/obsidian.nvim"] = {
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
    config = require("configs.langs.obsidian")
}

return custom
