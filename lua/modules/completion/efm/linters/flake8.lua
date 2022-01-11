return {
    prefix = "flake8",
    lintSource = "flake8",
    lintCommand = "flake8 --max-line-length 160 --extend-ignore F403,F405 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
    lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
    lintStdin = true,
    lintIgnoreExitCode = true
}
