#!/usr/bin/env bash

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `[[ -n "$(command)" ]]`, `func "$(command)"`, pipes, etc.
# shellcheck disable=SC2312

set -uo pipefail

# global-scope vars
REQUIRED_NVIM_VERSION=0.10.0
REQUIRED_NVIM_VERSION_LEGACY=0.9.0
USE_SSH=1
CLONE_ATTR=("--progress")
DEST_DIR="${HOME}/.config/nvim"
BACKUP_DIR="${DEST_DIR}_backup-$(date +%Y%m%dT%H%M%S)"

abort() {
	printf "%s\n" "$@" >&2
	exit 1
}

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]; then
	abort "Bash is required to interpret this script."
fi

# Check if script is run with force-interactive mode in CI
if [[ -n "${CI-}" && -n "${INTERACTIVE-}" ]]; then
	abort "Cannot run force-interactive mode in CI."
fi

# String formatters
if [[ -t 1 ]]; then
	tty_escape() { printf "\033[%sm" "$1"; }
else
	tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_yellow="$(tty_escape "0;33")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

shell_join() {
	local arg
	printf "%s" "$1"
	shift
	for arg in "$@"; do
		printf " "
		printf "%s" "${arg// /\ }"
	done
}

execute() {
	if ! "$@"; then
		abort "$(printf "Failed during: %s" "$(shell_join "$@")")"
	fi
}

major_minor() {
	echo "${1%%.*}.$(
		x="${1#*.}"
		echo "${x%%.*}"
	)"
}

chomp() {
	printf "%s" "${1/"$'\n'"/}"
}

info() {
	printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

info_ext() {
	printf "${tty_bold}    %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
	printf "${tty_yellow}Warning:${tty_reset} %s\n" "$(chomp "$1")"
}

warn_ext() {
	printf "         %s\n" "$(chomp "$1")"
}

getc() {
	local save_state
	save_state="$(/bin/stty -g)"
	/bin/stty raw -echo
	IFS='' read -r -n 1 -d '' "$@"
	/bin/stty "${save_state}"
}

ring_bell() {
	# Use the shell's audible bell
	if [[ -t 1 ]]; then
		printf "\a"
	fi
}

wait_for_user() {
	local c
	printf "\n"
	echo "Press ${tty_bold}RETURN${tty_reset}/${tty_bold}ENTER${tty_reset} to continue or any other key to abort..."
	getc c
	# we test for \r and \n because some stuff does \r instead
	if ! [[ "$c" == $'\r' || "$c" == $'\n' ]]; then
		abort "${tty_red}Aborted.${tty_reset}"
	fi
}

version_ge() {
	[[ "${1%.*}" -gt "${2%.*}" ]] || [[ "${1%.*}" -eq "${2%.*}" && "${1#*.}" -ge "${2#*.}" ]]
}

prompt_confirm() {
	local choice
	while true; do
		read -r -p "$1 [Y/n]: " choice
		case "$choice" in
		[yY][eE][sS] | [yY])
			return 1
			;;
		[nN][oO] | [nN])
			return 0
			;;
		*)
			if [[ -z "$choice" ]]; then
				return 1
			fi
			printf "${tty_red}%s\n\n${tty_reset}" "Input invalid! Please enter one of the following: '[y/yes]' or '[n/no]'."
			;;
		esac
	done
}

check_ssh() {
	info "Validating SSH connection..."
	ssh -T git@github.com &>/dev/null
	if ! [ $? -eq 1 ]; then
		info "We'll use HTTPS to fetch and update plugins."
		return 0
	else
		prompt_confirm "Do you prefer to use SSH to fetch and update plugins? (otherwise HTTPS)"
		return $?
	fi
}

clone_pref() {
	info "Checking 'git clone' preferences..."
	if ! prompt_confirm "Would you like to perform a shallow clone ('--depth=1')?"; then
		CLONE_ATTR+=("--depth=1")
	fi
}

check_nvim_version() {
	local nvim_version
	nvim_version="$(nvim --version | head -n1 | sed -e 's|^[^0-9]*||' -e 's| .*||')"
	if version_ge "$(major_minor "${nvim_version##* }")" "$(major_minor "$1")"; then
		return 0
	else
		return 1
	fi
}

clone_repo() {
	if check_nvim_version "${REQUIRED_NVIM_VERSION}"; then
		execute "git" "clone" "-b" "main" "${CLONE_ATTR[@]}" "$1" "${DEST_DIR}"
	elif check_nvim_version "${REQUIRED_NVIM_VERSION_LEGACY}"; then
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION})."
		info "Automatically redirecting you to the latest compatible version..."
		execute "git" "clone" "-b" "0.9" "${CLONE_ATTR[@]}" "$1" "${DEST_DIR}"
	else
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION_LEGACY})."
		abort "$(
			cat <<EOABORT
You have a legacy Neovim distribution installed.
Please make sure you have nvim v${REQUIRED_NVIM_VERSION_LEGACY} installed at the very least.
EOABORT
		)"
	fi
}

# Check if both `INTERACTIVE` and `NONINTERACTIVE` are set
# Always use single-quoted strings with `exp` expressions
# shellcheck disable=SC2016
if [[ -n "${INTERACTIVE-}" && -n "${NONINTERACTIVE-}" ]]; then
	abort 'Both `$INTERACTIVE` and `$NONINTERACTIVE` are set. Please unset at least one variable and try again.'
fi

# Check if script is run non-interactively (e.g. CI)
# If it is run non-interactively we should not prompt for confirmation.
# Always use single-quoted strings with `exp` expressions
# shellcheck disable=SC2016
if [[ -z "${NONINTERACTIVE-}" ]]; then
	if [[ -n "${CI-}" ]]; then
		warn 'Running in non-interactive mode because `$CI` is set.'
		NONINTERACTIVE=1
	elif [[ ! -t 0 ]]; then
		if [[ -z "${INTERACTIVE-}" ]]; then
			warn 'Running in non-interactive mode because `stdin` is not a TTY.'
			NONINTERACTIVE=1
		else
			warn 'Running in interactive mode despite `stdin` not being a TTY because `$INTERACTIVE` is set.'
		fi
	fi
else
	info 'Running in non-interactive mode because `$NONINTERACTIVE` is set.'
fi

if ! command -v perl >/dev/null; then
	abort "$(
		cat <<EOABORT
Perl is required to interpret this script. See:
  ${tty_underline}https://www.perl.org/get.html${tty_reset}
EOABORT
	)"
fi

if ! command -v nvim >/dev/null; then
	abort "$(
		cat <<EOABORT
You must install Neovim before installing this Nvim config. See:
  ${tty_underline}https://github.com/neovim/neovim/wiki/Installing-Neovim${tty_reset}
EOABORT
	)"
fi

if ! command -v git >/dev/null; then
	abort "$(
		cat <<EOABORT
You must install Git before installing this Nvim config. See:
  ${tty_underline}https://git-scm.com/${tty_reset}
EOABORT
	)"
fi

# Always use HTTPS when this script is run non-interactively (e.g. CI)
if [[ -n "${NONINTERACTIVE-}" ]]; then
	USE_SSH=0
fi

info "This script will install ayamir/nvimdots to:"
echo "${DEST_DIR}"

if [[ -d "${DEST_DIR}" ]]; then
	warn "The destination folder: \"${DEST_DIR}\" already exists."
	warn_ext "We will make a backup for you at \"${BACKUP_DIR}\"."
fi

if [[ -z "${NONINTERACTIVE-}" ]]; then
	ring_bell
	wait_for_user

	if check_ssh; then
		USE_SSH=0
	fi
	clone_pref
fi

if [[ -d "${DEST_DIR}" ]]; then
	execute "mv" "-f" "${DEST_DIR}" "${BACKUP_DIR}"
fi

info "Fetching in progress..."
if [[ "${USE_SSH}" -eq "1" ]]; then
	clone_repo "git@github.com:ayamir/nvimdots.git"
else
	clone_repo "https://github.com/ayamir/nvimdots.git"
fi

cd "${DEST_DIR}" || return
execute "cp" "-fRpP" "${DEST_DIR}/lua/user_template/" "${DEST_DIR}/lua/user"

if [[ "${USE_SSH}" -eq "0" ]]; then
	info "Changing default fetching method to HTTPS..."
	execute "perl" "-pi" "-e" "s/\[\"use_ssh\"\] \= true/\[\"use_ssh\"\] \= false/g" "${DEST_DIR}/lua/user/settings.lua"
fi

info "Spawning Neovim and fetching plugins... (You'll be redirected shortly)"
info "NOTE: Please make sure you have a Rust Toolchain installed ${tty_underline}via \`rustup\`${tty_reset}${tty_bold}! Otherwise, unexpected things may"
info_ext "      happen. See: ${tty_underline}https://www.rust-lang.org/tools/install${tty_reset}."
info_ext ""
info "If lazy.nvim failed to fetch any plugin(s), maunally execute \`:Lazy sync\` until everything is up-to-date."
cat <<EOS

Thank you for using this set of configuration!
- Project Homepage:
    ${tty_underline}https://github.com/ayamir/nvimdots${tty_reset}
- Further documentation (including executables you ${tty_bold}must${tty_reset} install for full functionality):
    ${tty_underline}https://github.com/ayamir/nvimdots/wiki/Prerequisites${tty_reset}
EOS

if [[ -z "${NONINTERACTIVE-}" ]]; then
	ring_bell
	wait_for_user
	nvim
fi
