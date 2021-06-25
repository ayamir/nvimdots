local disable_filetype = {"TelescopePrompt"}
local ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", "")
local enable_moveright = true
local enable_afterquote = true -- add bracket pairs after quote
local enable_check_bracket_line = true --- check bracket in same line
local check_ts = false

local npairs = require('nvim-autopairs')
npairs.setup()
