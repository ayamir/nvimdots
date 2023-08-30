#Requires -Version 7.1

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `func "$(command)"`, pipes, etc.

Set-StrictMode -Version 3.0

$ErrorActionPreference = "Stop" # Exit when command fails

# global-scope vars
$REQUIRED_NVIM_VERSION = [version]'0.9.0'
$REQUIRED_NVIM_VERSION_LEGACY = [version]'0.8.0'
$USE_SSH = $True

# package mgr vars
$choco_package_matrix = @{ "gcc" = "mingw"; "git" = "git"; "nvim" = "neovim"; "make" = "make"; "sudo" = "psutils"; "node" = "nodejs"; "pip" = "python3"; "fzf" = "fzf"; "rg" = "ripgrep"; "go" = "go"; "curl" = "curl"; "wget" = "wget"; "tree-sitter" = "tree-sitter"; "ruby" = "ruby"; "sqlite3" = "sqlite"; "rustc" = "rust-ms" }
$scoop_package_matrix = @{ "gcc" = "mingw"; "git" = "git"; "nvim" = "neovim"; "make" = "make"; "sudo" = "psutils"; "node" = "nodejs"; "pip" = "python"; "fzf" = "fzf"; "rg" = "ripgrep"; "go" = "go"; "curl" = "curl"; "wget" = "wget"; "tree-sitter" = "tree-sitter"; "ruby" = "ruby"; "sqlite3" = "sqlite"; "rustc" = "rust" }
$installer_pkg_matrix = @{ "NodeJS" = "npm"; "Python" = "pip"; "Ruby" = "gem" }

# env vars
$env:XDG_CONFIG_HOME ??= $env:LOCALAPPDATA
$env:CCPACK_MGR ??= 'unknown'
$env:CCLONE_BRANCH ??= 'main'
$env:CCLONE_ATTR ??= 'undef'
$env:CCDEST_DIR ??= "$env:XDG_CONFIG_HOME\nvim"
$env:CCBACKUP_DIR = "$env:CCDEST_DIR" + "_backup-" + (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmss")

function _abort ([Parameter(Mandatory = $True)] [string]$Msg,[Parameter(Mandatory = $True)] [string]$Type,[Parameter(Mandatory = $False)] [string]$Info_msg) {
	if ($Info_msg -ne $null) {
		Write-Host $Info_msg
	}
	Write-Error -Message "Error: $Msg" -Category $Type
	exit 1
}

function _chomp ([Parameter(Mandatory = $True)] [string]$Str) {
	return [string]::Join("\n",([string]::Join("\r",($Str.Split("`r"))).Split("`n")))
}

# Check if script is run with non-interactive mode, this is not allowed
# Returns $True if validation failed (i.e., in non-interactive mode)
function test_host {
	$NonInteractive = [System.Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }
	if ([System.Environment]::UserInteractive -and -not $NonInteractive) {
		return $False
	} else {
		return $True
	}
}

function info ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "==> " -ForegroundColor Blue -NoNewline; Write-Host $(_chomp -Str $Msg);
}

function info_ext ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "    $(_chomp -Str $Msg)"
}

function warn ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "Warning" -ForegroundColor Yellow -NoNewline; Write-Host ": $(_chomp -Str $Msg)";
}

function warn_ext ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "         $(_chomp -Str $Msg)"
}

function safe_execute ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [scriptblock]$WithCmd) {
	try {
		Invoke-Command -ErrorAction Stop -ScriptBlock $WithCmd
		if (-not $?) {
			throw # Also stop the script if cmd failed
		}
	}
	catch {
		_abort -Msg "Failed during: $WithCmd" -Type "InvalidResult"
	}
}

function wait_for_user {
	Write-Host ""
	Write-Host "Press " -NoNewline; Write-Host "RETURN" -ForegroundColor White -BackgroundColor DarkGray -NoNewline; Write-Host "/" -NoNewline; Write-Host "ENTER" -ForegroundColor White -BackgroundColor DarkGray -NoNewline; Write-Host " to continue or any other key to abort...";
	$ks = [System.Console]::ReadKey()
	if ($ks.Key -ne 'Enter') {
		Write-Host ""
		_abort -Msg "Aborted." -Type "OperationStopped"
	}
}

function check_ssh {
	info -Msg "Validating SSH connection..."
	Invoke-Command -ErrorAction SilentlyContinue -ScriptBlock { ssh -T git@github.com *> $null }
	if ($LastExitCode -ne 1) {
		info -Msg "We'll use HTTPS to fetch and update plugins."
		return $True
	} else {
		$_title = "Fetch Preferences"
		$_message = "Do you prefer to use SSH to fetch and update plugins? (otherwise HTTPS)"

		$_opt_ssh = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Will use SSH to fetch and update plugins in the future"
		$_opt_https = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Will use HTTPS to fetch and update plugins in the future"

		$USR_CHOICE = $Host.ui.PromptForChoice($_title,$_message,[System.Management.Automation.Host.ChoiceDescription[]]($_opt_ssh,$_opt_https),0)
		if ($USR_CHOICE -eq 0) {
			return $False
		} else {
			return $True
		}
	}
}

function check_clone_pref {
	info -Msg "Checking 'git clone' preferences..."

	$_title = "'git clone' Preferences"
	$_message = "Would you like to perform a shallow clone ('--depth=1')?"

	$_opt_yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Will append '--depth=1' to 'git clone' options"
	$_opt_no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Do nothing"

	$USR_CHOICE = $Host.ui.PromptForChoice($_title,$_message,[System.Management.Automation.Host.ChoiceDescription[]]($_opt_yes,$_opt_no),0)
	if ($USR_CHOICE -eq 0) {
		$env:CCLONE_ATTR = '--depth=1'
	} else {
		$env:CCLONE_ATTR = '--progress'
	}
}

function check_in_path ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$WithName) {
	if ((Get-Command $WithName -ErrorAction SilentlyContinue)) {
		return $True
	} else {
		return $False
	}
}

function query_pack {
	if ((check_in_path -WithName "scoop") -and (check_in_path -WithName "choco")) {
		info -Msg "   [Detected] Multiple package managers detected."

		$_title = "Package manager Preferences"
		$_message = "Pick your favorite package manager"

		$_opt_scoop = New-Object System.Management.Automation.Host.ChoiceDescription "&Scoop","Will use 'scoop' to install dependencies"
		$_opt_choco = New-Object System.Management.Automation.Host.ChoiceDescription "&Chocolatey","Will use 'choco' to install dependencies"

		$USR_CHOICE = $Host.ui.PromptForChoice($_title,$_message,[System.Management.Automation.Host.ChoiceDescription[]]($_opt_scoop,$_opt_choco),0)
		if ($USR_CHOICE -eq 0) {
			$env:CCPACK_MGR = 'scoop'
		} else {
			$env:CCPACK_MGR = 'choco'
		}
	} elseif ((check_in_path -WithName "scoop")) {
		info -Msg "   [Detected] We'll use 'Scoop' as the default package mgr."
		$env:CCPACK_MGR = 'scoop'
	} elseif ((check_in_path -WithName "choco")) {
		info -Msg "   [Detected] We'll use 'Chocolatey' as the default package mgr."
		$env:CCPACK_MGR = 'choco'
	} else {
		_abort -Msg "Required executable not found." -Type "NotInstalled" -Info_msg @'
You must install a modern package manager before installing this Nvim config.
Avaliable choices are:
  - Chocolatey
    https://chocolatey.org/install#individual
    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
  - Scoop
    https://scoop.sh/
    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "scoop" and "choco" are both either not installed, missing from PATH, or not executable.

'@
	}
}

function init_pack {
	info -Msg "Initializing package manager preferences..."
	if ($env:CCPACK_MGR -ne 'unknown') {
		info -Msg '$env:CCPACK_MGR already defined. Validating...'
		if (($env:CCPACK_MGR -eq 'choco') -and (check_in_path -WithName $env:CCPACK_MGR)) {
			info -Msg "We'll use 'Chocolatey' as the default package mgr."
		} elseif (($env:CCPACK_MGR -eq 'scoop') -and (check_in_path -WithName $env:CCPACK_MGR)) {
			info -Msg "We'll use 'Scoop' as the default package mgr."
		} else {
			info -Msg "Validation failed. Fallback to query."
			query_pack
		}
	} else {
		query_pack
	}
}

function _install_exe ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$WithName) {
	if ($env:CCPACK_MGR -eq 'choco') {
		Write-Host "Attempting to install dependency [" -NoNewline; Write-Host $WithName -ForegroundColor Green -NoNewline; Write-Host "] with Chocolatey"
		$_inst_name = $choco_package_matrix[$WithName]
		safe_execute -WithCmd { choco install "$_inst_name" -y }
	}
	elseif ($env:CCPACK_MGR -eq 'scoop') {
		Write-Host "Attempting to install dependency [" -NoNewline; Write-Host $WithName -ForegroundColor Green -NoNewline; Write-Host "] with Scoop"
		$_inst_name = $scoop_package_matrix[$WithName]
		safe_execute -WithCmd { scoop install "$_inst_name" }
	} else {
		_abort -Msg 'This function is invoked incorrectly - Invalid data: $env:CCPACK_MGR' -Type "InvalidOperation"
	}
}

function _install_nodejs_deps {
	safe_execute -WithCmd { npm install --global neovim tree-sitter-cli }
}

function _install_python_deps {
	safe_execute -WithCmd { python -m pip install --user wheel }
	safe_execute -WithCmd { python -m pip install --user pynvim }
}

function _install_ruby_deps {
	safe_execute -WithCmd { gem install neovim }
	safe_execute -WithCmd { ridk install }
}

function check_and_fetch_exec ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$PkgName) {
	$_str = "Checking dependency: '$PkgName'" + " " * 15
	Write-Host $_str.substring(0,[System.Math]::Min(40,$_str.Length)) -NoNewline

	if (-not (check_in_path -WithName $PkgName)) {
		Start-Sleep -Milliseconds 350
		Write-Host "Failed" -ForegroundColor Red
		_install_exe -WithName $PkgName
	} else {
		Start-Sleep -Milliseconds 350
		Write-Host "Success" -ForegroundColor Green
	}
}

function confirm_dep_inst ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [string]$PkgName) {
	$_inst_name = $installer_pkg_matrix[$PkgName]
	if (-not (check_in_path -WithName "$_inst_name")) {
		_abort -Msg "This function is invoked incorrectly - The '$_inst_name' executable not found" -Type "InvalidOperation"
	} else {
		$_title = "Dependencies Installation"
		$_message = "Would you like to check & install $PkgName dependencies?"

		$_opt_yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Will install $PkgName dependencies"
		$_opt_no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Will SKIP installing $PkgName dependencies"

		$USR_CHOICE = $Host.ui.PromptForChoice($_title,$_message,[System.Management.Automation.Host.ChoiceDescription[]]($_opt_yes,$_opt_no),0)
		if ($USR_CHOICE -eq 0) {
			return $True
		} else {
			return $False
		}
	}
}

function fetch_deps {
	check_and_fetch_exec -PkgName "gcc"
	check_and_fetch_exec -PkgName "git"
	check_and_fetch_exec -PkgName "nvim"
	check_and_fetch_exec -PkgName "make"
	check_and_fetch_exec -PkgName "sudo"
	check_and_fetch_exec -PkgName "node"
	check_and_fetch_exec -PkgName "pip"
	check_and_fetch_exec -PkgName "fzf"
	check_and_fetch_exec -PkgName "rg"
	check_and_fetch_exec -PkgName "ruby"
	check_and_fetch_exec -PkgName "go"
	check_and_fetch_exec -PkgName "curl"
	check_and_fetch_exec -PkgName "wget"
	check_and_fetch_exec -PkgName "rustc"
	check_and_fetch_exec -PkgName "sqlite3"
	check_and_fetch_exec -PkgName "tree-sitter"

	# Reload PATH for future use
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function check_nvim_version ([Parameter(Mandatory = $True)][ValidateNotNullOrEmpty()] [version]$RequiredVersionMin) {
	$nvim_version = Invoke-Command -ErrorAction SilentlyContinue -ScriptBlock { nvim --version } # First get neovim version
	$nvim_version = $nvim_version.Split([System.Environment]::NewLine) | Select-Object -First 1 # Then do head -n1
	$nvim_version = $nvim_version.Split('-') | Select-Object -First 1 # Special for dev branches
	$nvim_version = $nvim_version -replace '[^(\d+(\.\d+)*)]','' # Then do regex replacement similar to sed

	$nvim_version = [version]$nvim_version
	return ($nvim_version -ge $RequiredVersionMin)
}

function ring_bell {
	[System.Console]::beep()
}

function _main {
	if (-not $IsWindows) {
		_abort -Msg "This install script can only execute on Windows." -Type "DeviceError"
	}

	if ((test_host)) {
		_abort -Msg "This script cannot proceed in non-interactive mode." -Type "NotImplemented"
	}

	info -Msg "Checking dependencies..."

	init_pack
	fetch_deps

	if ((confirm_dep_inst -PkgName "NodeJS")) {
		_install_nodejs_deps
	}
	if ((confirm_dep_inst -PkgName "Python")) {
		_install_python_deps
	}
	if ((confirm_dep_inst -PkgName "Ruby")) {
		_install_ruby_deps
	}

	# Check dependencies
	if (-not (check_in_path -WithName "nvim")) {
		_abort -Msg "Required executable not found." -Type "NotInstalled" -Info_msg @'
You must install Neovim before installing this Nvim config. See:
  https://github.com/neovim/neovim/wiki/Installing-Neovim
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "nvim" is either not installed, missing from PATH, or not executable.

'@
	}

	if (-not (check_in_path -WithName "git")) {
		_abort -Msg "Required executable not found." -Type "NotInstalled" -Info_msg @'
You must install Git before installing this Nvim config. See:
  https://git-scm.com/
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "git" is either not installed, missing from PATH, or not executable.

'@
	}

	info -Msg "This script will install ayamir/nvimdots to:"
	Write-Host $env:CCDEST_DIR

	if ((Test-Path $env:CCDEST_DIR)) {
		warn -Msg "The destination folder: `"$env:CCDEST_DIR`" already exists."
		warn_ext -Msg "We will make a backup for you at `"$env:CCBACKUP_DIR`"."
	}

	ring_bell
	wait_for_user
	if ((check_ssh)) {
		$USE_SSH = $False
	}
	check_clone_pref

	if ((Test-Path $env:CCDEST_DIR)) {
		safe_execute -WithCmd { Move-Item -Path "$env:CCDEST_DIR" -Destination "$env:CCBACKUP_DIR" -Force }
	}

	info -Msg "Fetching in progress..."

	if ($USE_SSH) {
		if ((check_nvim_version -RequiredVersionMin $REQUIRED_NVIM_VERSION)) {
			safe_execute -WithCmd { git clone --progress -b "$env:CCLONE_BRANCH" "$env:CCLONE_ATTR" 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} elseif ((check_nvim_version -RequiredVersionMin $REQUIRED_NVIM_VERSION_LEGACY)) {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
			info -Msg "Automatically redirecting you to the latest compatible version..."
			safe_execute -WithCmd { git clone --progress -b 0.8 "$env:CCLONE_ATTR" 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} else {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION_LEGACY)."
			_abort -Msg "This Neovim distribution is no longer supported." -Type "NotImplemented" -Info_msg @"
You have a legacy Neovim distribution installed.
Please make sure you have nvim v$REQUIRED_NVIM_VERSION_LEGACY installed at the very least.

"@
		}
	} else {
		if ((check_nvim_version -RequiredVersionMin $REQUIRED_NVIM_VERSION)) {
			safe_execute -WithCmd { git clone --progress -b "$env:CCLONE_BRANCH" "$env:CCLONE_ATTR" 'https://github.com/ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} elseif ((check_nvim_version -RequiredVersionMin $REQUIRED_NVIM_VERSION_LEGACY)) {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
			info -Msg "Automatically redirecting you to the latest compatible version..."
			safe_execute -WithCmd { git clone --progress -b 0.8 "$env:CCLONE_ATTR" 'https://github.com/ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} else {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION_LEGACY)."
			_abort -Msg "This Neovim distribution is no longer supported." -Type "NotImplemented" -Info_msg @"
You have a legacy Neovim distribution installed.
Please make sure you have nvim v$REQUIRED_NVIM_VERSION_LEGACY installed at the very least.

"@
		}
	}

	safe_execute -WithCmd { Set-Location -Path "$env:CCDEST_DIR" }

	if (-not $USE_SSH) {
		info -Msg "Changing default fetching method to HTTPS..."
		safe_execute -WithCmd {
			(Get-Content "$env:CCDEST_DIR\lua\user\settings.lua") |
			ForEach-Object { $_ -replace '\["use_ssh"\] = true','["use_ssh"] = false' } |
			Set-Content "$env:CCDEST_DIR\lua\user\settings.lua"
		}
	}

	info -Msg "Spawning Neovim and fetching plugins... (You'll be redirected shortly)"
	info -Msg 'To make sqlite work with lua, manually grab the dlls from "https://www.sqlite.org/download.html" and replace'
	info_ext -Msg 'vim.g.sqlite_clib_path with your path at the bottom of `lua/core/options.lua`.'
	info -Msg 'Also, please make sure you have a Rust Toolchain installed via `rustup`! Otherwise, unexpected things may'
	info_ext -Msg 'happen. See: https://www.rust-lang.org/tools/install.      ¯¯¯¯¯¯¯¯¯¯¯¯'
	info_ext -Msg '             ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯'
	info -Msg 'If lazy.nvim failed to fetch any plugin(s), maunally execute `:Lazy sync` until everything is up-to-date.'
	Write-Host @'

Thank you for using this set of configuration!
- Project Homepage:
    https://github.com/ayamir/nvimdots
    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
- Further documentation (including executables you |must| install for full functionality):
    https://github.com/ayamir/nvimdots/wiki/Prerequisites
    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
'@

	ring_bell
	wait_for_user

	safe_execute -WithCmd { nvim }

	# Exit the script
	exit
}

_main
