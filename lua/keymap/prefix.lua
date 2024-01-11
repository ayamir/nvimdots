local icons = {
  ui_sep = require("modules.utils.icons").get("ui", true)
}

--- Need to expand by hand
local prefix_desc = {
  ["<leader>b"] = icons.ui_sep.Buffer .. "Buffer"
}

return prefix_desc
