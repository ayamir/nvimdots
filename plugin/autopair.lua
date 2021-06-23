local disable_filetype = { "TelescopePrompt" }
local ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]],"%s+", "")
local enable_moveright = true
local enable_afterquote = true  -- add bracket pairs after quote
local enable_check_bracket_line = true  --- check bracket in same line
local check_ts = false

local npairs = require('nvim-autopairs')
local remap = vim.api.nvim_set_keymap

-- skip it, if you use another global object
_G.MUtils= {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
if vim.fn.pumvisible() ~= 0  then
  if vim.fn.complete_info()["selected"] ~= -1 then
    return vim.fn["compe#confirm"](npairs.esc("<cr>"))
  else
    return npairs.esc("<cr>")
  end
else
  return npairs.autopairs_cr()
end
end

remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
npairs.setup()
