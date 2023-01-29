#Requires -Version 7.1

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `func "$(command)"`, pipes, etc.

Set-StrictMode -Version 3.0

$ErrorActionPreference = "Stop" # Exit when command fails

# global-scope vars
$CLONE_BRANCH ??= 'main'
$REQUIRED_NVIM_VERSION = [version]'0.8.0'
$USE_SSH = $True
$NVIM_EXE = $False
$GIT_EXE = $False

# env vars
$env:XDG_CONFIG_HOME ??= $env:LOCALAPPDATA
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
	Write-Host "==> " -ForegroundColor Blue -NoNewline; Write-Host $(_chomp -Str $Msg) -ForegroundColor White;
}

function warn ([Parameter(Mandatory = $True,ValueFromPipeline = $True)][ValidateNotNullOrEmpty()] [string]$Msg) {
	Write-Host "Warning" -ForegroundColor Yellow -NoNewline; Write-Host ": $(_chomp -Str $Msg)" -ForegroundColor White;
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
	Write-Host "Press " -NoNewline; Write-Host "RETURN" -ForegroundColor White -NoNewline; Write-Host "/" -NoNewline; Write-Host "ENTER" -ForegroundColor White -NoNewline; Write-Host " to continue or any other key to abort...";
	$ks = [console]::ReadKey()
	if ($ks.Key -ne 'Enter') {
		Write-Host ""
		Write-Error -Message "Aborted." -Category OperationStopped
		exit 1
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

function Is-Latest ([Parameter(Mandatory = $True,ValueFromPipeline = $True)] [bool]$hasEXEnvim) {
	if ($hasEXEnvim) {
		$nvim_version = Invoke-Command -ErrorAction SilentlyContinue -ScriptBlock { nvim.exe --version } # First get neovim version
	} else {
		$nvim_version = Invoke-Command -ErrorAction SilentlyContinue -ScriptBlock { nvim --version } # First get neovim version
	}
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

# Check dependencies
if (((Get-Command "nvim" -ErrorAction SilentlyContinue) -eq $null) -and ((Get-Command "nvim.exe" -ErrorAction SilentlyContinue) -eq $null)) {
	_abort -Msg "Required executable file not found." -Type "NotInstalled" -Info_msg @'
You must install NeoVim before installing this Nvim config. See:
  https://github.com/neovim/neovim/wiki/Installing-Neovim
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "nvim" is either not installed, missing from PATH, or not executable.

'@
} else {
	if (Get-Command "nvim" -ErrorAction SilentlyContinue)
	{
		$NVIM_EXE = $False
	} else {
		$NVIM_EXE = $True
	}
}

if (((Get-Command "git" -ErrorAction SilentlyContinue) -eq $null) -and ((Get-Command "git.exe" -ErrorAction SilentlyContinue) -eq $null)) {
	_abort -Msg "Required executable file not found." -Type "NotInstalled" -Info_msg @'
You must install Git before installing this Nvim config. See:
  https://git-scm.com/
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
[INFO] "git" is either not installed, missing from PATH, or not executable.

'@
} else {
	if (Get-Command "git" -ErrorAction SilentlyContinue)
	{
		$GIT_EXE = $False
	} else {
		$GIT_EXE = $True
	}
}

prompt -Msg "This script will install ayamir/nvimdots to:"
Write-Host $env:CCDEST_DIR

if (Test-Path $env:CCDEST_DIR) {
	warn -Msg "The destination folder: `"$env:CCDEST_DIR`" already exists."
	warn-Ext -Msg "We will make a backup for you at `"$env:CCBACKUP_DIR`"."
}

Ring-Bell
Wait-For-User
if ((Check-SSH)) {
	$USE_SSH = $False
}

if (Test-Path $env:CCDEST_DIR) {
	Safe-Execute -WithCmd { Move-Item -Path "$env:CCDEST_DIR" -Destination "$env:CCBACKUP_DIR" -Force }
}

prompt -Msg "Fetching in progress..."

if ($USE_SSH) {
	if ($GIT_EXE) {
		if ((Is-Latest -hasEXEnvim $NVIM_EXE)) {
			Safe-Execute -WithCmd { git.exe clone -b main 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} else {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
			prompt -Msg "Automatically redirecting you to legacy version..."
			Safe-Execute -WithCmd { git.exe clone -b 0.7 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		}
	} else {
		if ((Is-Latest -hasEXEnvim $NVIM_EXE)) {
			Safe-Execute -WithCmd { git clone -b main 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} else {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
			prompt -Msg "Automatically redirecting you to legacy version..."
			Safe-Execute -WithCmd { git clone -b 0.7 'git@github.com:ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		}
	}
} else {
	if ($GIT_EXE) {
		if ((Is-Latest -hasEXEnvim $NVIM_EXE)) {
			Safe-Execute -WithCmd { git.exe clone -b main 'https://github.com/ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} else {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
			prompt -Msg "Automatically redirecting you to legacy version..."
			Safe-Execute -WithCmd { git.exe clone -b 0.7 https://github.com/ayamir/nvimdots.git "$env:CCDEST_DIR" }
		}
	} else {
		if ((Is-Latest -hasEXEnvim $NVIM_EXE)) {
			Safe-Execute -WithCmd { git clone -b main 'https://github.com/ayamir/nvimdots.git' "$env:CCDEST_DIR" }
		} else {
			warn -Msg "You have outdated Nvim installed (< $REQUIRED_NVIM_VERSION)."
			prompt -Msg "Automatically redirecting you to legacy version..."
			Safe-Execute -WithCmd { git clone -b 0.7 https://github.com/ayamir/nvimdots.git "$env:CCDEST_DIR" }
		}
	}
}

Safe-Execute -WithCmd { Set-Location -Path "$env:CCDEST_DIR" }

if (-not $USE_SSH) {
	prompt -Msg "Changing default fetching method to HTTPS..."
	Safe-Execute -WithCmd { (Get-Content "$env:CCDEST_DIR\lua\core\settings.lua") | ForEach-Object { $_ -replace '\["use_ssh"\] = true','["use_ssh"] = false' } | Set-Content "$env:CCDEST_DIR\lua\core\settings.lua" }
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

Wait-For-User

if ($NVIM_EXE) {
	Safe-Execute -WithCmd { nvim.exe "+Lazy sync" }
} else {
	Safe-Execute -WithCmd { nvim "+Lazy sync" }
}
