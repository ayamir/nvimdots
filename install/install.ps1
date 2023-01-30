#Requires -Version 7.1

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `func "$(command)"`, pipes, etc.

Set-StrictMode -Version 3.0

$ErrorActionPreference = "Stop" # Exit when command fails

# global-scope vars
$REQUIRED_NVIM_VERSION = [version]'0.8.0'
$USE_SSH = $True

# package mgr vars
$choco_package_matrix = @{ "git" = "git"; "nvim" = "neovim"; "make" = "make"; "node" = "nodejs"; "pip" = "python3"; "fzf" = "fzf"; "go" = "go"; "curl" = "curl"; "wget" = "wget"; "tree-sitter" = "tree-sitter"; "ruby" = "ruby"; "rustc" = "rust-ms" }
$scoop_package_matrix = @{ "git" = "git"; "nvim" = "neovim"; "make" = "make"; "node" = "nodejs"; "pip" = "python3"; "fzf" = "fzf"; "go" = "go"; "curl" = "curl"; "wget" = "wget"; "tree-sitter" = "tree-sitter"; "ruby" = "ruby"; "rustc" = "rust" }

# env vars
$env:XDG_CONFIG_HOME ??= $env:LOCALAPPDATA
$env:CCPACK_MGR ??= 'unknown'
$env:CCLONE_BRANCH ??= 'main'
$env:CCDEST_DIR ??= "$env:XDG_CONFIG_HOME\nvim"
$env:CCBACKUP_DIR = "$env:CCDEST_DIR" + "_backup-" + (Get-Date).ToUniversalTime().ToString("yyyyMMddTHHmmss")

function _abort ([Parameter(Mandatory = $True,ValueFromPipeline = $True)] [string]$Msg,[Parameter(Mandatory = $True)] [string]$Type,[Parameter(Mandatory = $False)] [string]$Info_msg) {
	if ($Info_msg -ne $null) {
		Write-Host $Info_msg
	}
	Write-Error -Message "Error: $Msg" -Category $Type
	exit 1
}

function _chomp ([Parameter(Mandatory = $True,ValueFromPipeline = $True)] [string]$Str) {
	return [string]::Join("\n",([string]::Join("\r",($Str.Split("`r"))).Split("`n")))
}

# Check if script is run with non-interactive mode, this is not allowed
# Returns $True if validation failed (i.e., in non-interactive mode)
function Test-OpType {
	$NonInteractive = [Environment]::GetCommandLineArgs() | Where-Object { $_ -like '-NonI*' }
	if ([Environment]::UserInteractive -and -not $NonInteractive) {
		return $False
	}
	return $True
}

function prompt ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "==> " -ForegroundColor Blue -NoNewline; Write-Host $(_chomp -Str $Msg);
}

function warn ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "Warning" -ForegroundColor Yellow -NoNewline; Write-Host ": $(_chomp -Str $Msg)";
}
function warn-Ext ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "         $(_chomp -Str $Msg)"
}

function Safe-Execute ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [scriptblock]$WithCmd) {
	try {
		Invoke-Command -ErrorAction Stop -ScriptBlock $WithCmd
		if (-not $?) {
			throw # Also stop the script if cmd failed
		}
	}
	catch {
		_abort -Msg "Failed during: $WithCmd" -Type "InvalidResult"
		exit 1
	}
}

function Wait-For-User {
	Write-Host ""
	Write-Host "Press " -NoNewline; Write-Host "RETURN" -ForegroundColor White -BackgroundColor DarkGray -NoNewline; Write-Host "/" -NoNewline; Write-Host "ENTER" -ForegroundColor White -BackgroundColor DarkGray -NoNewline; Write-Host " to continue or any other key to abort...";
	$ks = [console]::ReadKey()
	if ($ks.Key -ne 'Enter') {
		Write-Host ""
		_abort -Msg "Aborted." -Type "OperationStopped"
	}
}

function Check-SSH {
	prompt -Msg "Validating SSH connection..."
	Invoke-Command -ErrorAction SilentlyContinue -ScriptBlock { ssh -T git@github.com *> $null }
	if ($LastExitCode -ne 1) {
		prompt -Msg "We'll use HTTPS to fetch and update plugins."
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

function Check-Def-Exe ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$WithName) {
	if ((Get-Command $WithName -ErrorAction SilentlyContinue)) {
		return $True
	} else {
		return $False
	}
}

function Query-Pack {
	if ((Check-Def-Exe -WithName "scoop") -and (Check-Def-Exe -WithName "choco")) {
		prompt -Msg " [Detected] Multiple package mgrs detected."

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
	} elseif ((Check-Def-Exe -WithName "scoop")) {
		prompt -Msg " [Detected] We'll use 'Scoop' as the default package mgr."
		$env:CCPACK_MGR = 'scoop'
	} elseif ((Check-Def-Exe -WithName "choco")) {
		prompt -Msg " [Detected] We'll use 'Chocolatey' as the default package mgr."
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

function Init-Pack {
	prompt -Msg "Intializing package manager preferences..."
	if ($env:CCPACK_MGR -ne 'unknown') {
		prompt -Msg '$env:CCPACK_MGR already defined. Validating...'
		if (($env:CCPACK_MGR -eq 'choco') -and (Check-Def-Exe -WithName $env:CCPACK_MGR)) {
			prompt -Msg "We'll use 'Chocolatey' as the default package mgr."
		} elseif (($env:CCPACK_MGR -eq 'scoop') -and (Check-Def-Exe -WithName $env:CCPACK_MGR)) {
			prompt -Msg "We'll use 'Scoop' as the default package mgr."
		} else {
			prompt -Msg "Validation faled. Fallback to query."
			Query-Pack
		}
	} else {
		Query-Pack
	}
}

function _install_exe ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$WithName) {
	if ($env:CCPACK_MGR -eq 'choco') {
		Write-Host "Attempting to install dependency [" -NoNewline; Write-Host $WithName -ForegroundColor Green -NoNewline; Write-Host "] with Chocolatey"
		Safe-Execute -WithCmd { choco install "$choco_package_matrix[$WithName]" }
	}
	elseif ($env:CCPACK_MGR -eq 'scoop') {
		Write-Host "Attempting to install dependency [" -NoNewline; Write-Host $WithName -ForegroundColor Green -NoNewline; Write-Host "] with Scoop"
		Safe-Execute -WithCmd { scoop install "$scoop_package_matrix[$WithName]" }
	} else {
		_abort -Msg 'This function is invoked incorrectly - invalid data: $env:CCPACK_MGR' -Type "InvalidOperation"
	}
}

function _install_nodejs_deps {
	Safe-Execute -WithCmd { npm install --global neovim tree-sitter-cli }
}

function _install_python_deps {
	Safe-Execute -WithCmd { python -m pip install --user pynvim }
}

function _install_ruby_deps {
	Safe-Execute -WithCmd { gem install neovim }
}

function Check-And-Fetch-Exe ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$PkgName) {
	if (-not (Check-Def-Exe -WithName $PkgName)) {
		_install_exe -WithName $PkgName
	}
}

function Check-Dep-Choice ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$PkgName) {
	if (-not (Check-Def-Exe -WithName $PkgName)) {
		_abort -Msg 'This function is invoked incorrectly - executable not found' -Type "InvalidOperation"
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

function Fetch-Deps {
	Check-And-Fetch-Exe -PkgName "git"
	Check-And-Fetch-Exe -PkgName "nvim"
	Check-And-Fetch-Exe -PkgName "make"
	Check-And-Fetch-Exe -PkgName "node"
	Check-And-Fetch-Exe -PkgName "pip"
	Check-And-Fetch-Exe -PkgName "fzf"
	Check-And-Fetch-Exe -PkgName "tree-sitter"
	Check-And-Fetch-Exe -PkgName "ruby"
	Check-And-Fetch-Exe -PkgName "go"
	Check-And-Fetch-Exe -PkgName "curl"
	Check-And-Fetch-Exe -PkgName "wget"
	Check-And-Fetch-Exe -PkgName "rustc"
}

function Is-Latest {
	$nvim_version = Invoke-Command -ErrorAction SilentlyContinue -ScriptBlock { nvim --version } # First get neovim version
	$nvim_version = $nvim_version.Split([Environment]::NewLine) | Select-Object -First 1 # Then do head -n1
	$nvim_version = $nvim_version.Split('-') | Select-Object -First 1 # Special for dev branches
	$nvim_version = $nvim_version -replace '[^(\d+(\.\d+)*)]','' # Then do regex replacement similar to sed

	$nvim_version = [version]$nvim_version
	return ($nvim_version -ge $REQUIRED_NVIM_VERSION)
}

function Ring-Bell {
	[console]::beep()
}

if (-not $IsWindows) {
	_abort -Msg "This install script can only execute on Windows." -Type "DeviceError"
}

if ((Test-OpType)) {
	_abort -Msg "This script cannot proceed in non-interactive mode." -Type "NotImplemented"
}

prompt -Msg "Checking dependencies..."

Init-Pack
Fetch-Deps

if ((Check-Dep-Choice -PkgName "NodeJS")) {
	_install_nodejs_deps
}
if ((Check-Dep-Choice -PkgName "Python")) {
	_install_python_deps
}
if ((Check-Dep-Choice -PkgName "Ruby")) {
	_install_ruby_deps
}

# Check dependencies
if ((Get-Command "nvim" -ErrorAction SilentlyContinue) -eq $null) {
	_abort -Msg "Required executable not found." -Type "NotInstalled" -Info_msg @'
You must install NeoVim before installing this Nvim config. See:
  https://github.com/neovim/neovim/wiki/Installing-Neovim
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "nvim" is either not installed, missing from PATH, or not executable.

'@
}

if ((Get-Command "git" -ErrorAction SilentlyContinue) -eq $null) {
	_abort -Msg "Required executable not found." -Type "NotInstalled" -Info_msg @'
You must install Git before installing this Nvim config. See:
  https://git-scm.com/
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "git" is either not installed, missing from PATH, or not executable.

'@
}

prompt -Msg "This script will install ayamir/nvimdots to:"
Write-Host $env:CCDEST_DIR

if ((Test-Path $env:CCDEST_DIR)) {
	warn -Msg "The destination folder: `"$env:CCDEST_DIR`" already exists."
	warn-Ext -Msg "We will make a backup for you at `"$env:CCBACKUP_DIR`"."
}

Ring-Bell
Wait-For-User
if ((Check-SSH)) {
	$USE_SSH = $False
}

if ((Test-Path $env:CCDEST_DIR)) {
	Safe-Execute -WithCmd { Move-Item -Path "$env:CCDEST_DIR" -Destination "$env:CCBACKUP_DIR" -Force }
}

prompt -Msg "Fetching in progress..."

if ($USE_SSH) {
	if ((Is-Latest)) {
		Safe-Execute -WithCmd { git clone -b "$env:CCLONE_BRANCH" 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
	} else {
		warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
		prompt -Msg "Automatically redirecting you to legacy version..."
		Safe-Execute -WithCmd { git clone -b 0.7 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
	}
} else {
	if ((Is-Latest)) {
		Safe-Execute -WithCmd { git clone -b "$env:CCLONE_BRANCH" 'https://github.com/ayamir/nvimdots.git' "$env:CCDEST_DIR" }
	} else {
		warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
		prompt -Msg "Automatically redirecting you to legacy version..."
		Safe-Execute -WithCmd { git clone -b 0.7 'https://github.com/ayamir/nvimdots.git' "$env:CCDEST_DIR" }
	}
}

Safe-Execute -WithCmd { Set-Location -Path "$env:CCDEST_DIR" }

if (-not $USE_SSH) {
	prompt -Msg "Changing default fetching method to HTTPS..."
	Safe-Execute -WithCmd {
		(Get-Content "$env:CCDEST_DIR\lua\core\settings.lua") |
		ForEach-Object { $_ -replace '\["use_ssh"\] = true','["use_ssh"] = false' } |
		Set-Content "$env:CCDEST_DIR\lua\core\settings.lua"
	}
}

prompt "Spawning neovim and fetching plugins... (You'll be redirected shortly)"
prompt 'If lazy.nvim failed to fetch any plugin(s), maunally execute `nvim "+Lazy sync"` until everything is up-to-date.'
Write-Host @'

Thank you for using this set of configuration!
- Project Homepage:
    https://github.com/ayamir/nvimdots
    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
- Further documentation (including executables you |must| install for full functionality):
    https://github.com/ayamir/nvimdots/wiki/Prerequisites
    ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
'@

Ring-Bell
Wait-For-User

Safe-Execute -WithCmd { nvim "+Lazy sync" }
