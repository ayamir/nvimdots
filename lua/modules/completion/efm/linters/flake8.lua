local linter = 'flake8-too-many'
local command = string.format('%s -', linter)

return {
    prefix = linter,
    lintCommand = command,
    lintStdin = true,
    lintFormats = {'%.%#:%l:%c: %t%.%# %m'},
    rootMarkers = {'setup.cfg', 'tox.ini', '.flake8'}
}
