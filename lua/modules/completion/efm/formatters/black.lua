local formatter = 'black'
local command = string.format('%s --no-color -q -', formatter)

return {
  formatCommand = command,
  formatStdin = true,
}
