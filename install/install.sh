#!/bin/bash

# We don't need return codes for "$(command)", only stdout is needed.
# Allow `[[ -n "$(command)" ]]`, `func "$(command)"`, pipes, etc.
# shellcheck disable=SC2312

set -u

# global vars
DEST_DIR="${HOME}/.config/nvim"
REQUIRED_NVIM_VERSION=0.8
USE_SSH=1

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

# string formatters
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

prompt() {
	printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
	printf "${tty_yellow}Warning${tty_reset}: %s\n" "$(chomp "$1")"
}

getc() {
	local save_state
	save_state="$(/bin/stty -g)"
	/bin/stty raw -echo
	IFS='' read -r -n 1 -d '' "$@"
	/bin/stty "${save_state}"
}

ring_bell() {
	# Use the shell's audible bell.
	if [[ -t 1 ]]; then
		printf "\a"
	fi
}

wait_for_user() {
	local c
	echo
	echo "Press ${tty_bold}RETURN${tty_reset}/${tty_bold}ENTER${tty_reset} to continue or any other key to abort..."
	getc c
	# we test for \r and \n because some stuff does \r instead
	if ! [[ "${c}" == $'\r' || "${c}" == $'\n' ]]; then
		echo "${tty_red}Aborted.${tty_reset}"
		exit 1
	fi
}

version_ge() {
	[[ "${1%.*}" -gt "${2%.*}" ]] || [[ "${1%.*}" -eq "${2%.*}" && "${1#*.}" -ge "${2#*.}" ]]
}

check_ssh() {
	prompt "Validating SSH connection..."
	ssh -T git@github.com &>/dev/null
	if ! [ $? -eq 1 ]; then
		prompt "We'll use HTTPS to fetch and update plugins."
		return 0
	else
		printf "Do you prefer to use SSH to fetch and update plugins? (otherwise HTTPS) [Y/n] "
		read -r USR_CHOICE
		if [[ $USR_CHOICE == [nN] || $USR_CHOICE == [Nn][Oo] ]]; then
			return 0
		else
			return 1
		fi
	fi
}

is_latest() {
	local nvim_version
	nvim_version=$(nvim --version | head -n1 | sed -e 's|^[^0-9]*||' -e 's| .*||')
	if version_ge "$(major_minor "${nvim_version##* }")" "$(major_minor "${REQUIRED_NVIM_VERSION}")"; then
		return 0
	else
		return 1
	fi
}

if ! command -v nvim >/dev/null; then
	abort "$(
		cat <<EOABORT
You must install NeoVim before installing this Nvim config. See:
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

prompt "This script will install ayamir/nvimdots to:"
echo "${DEST_DIR}"

if [[ -d "${DEST_DIR}" ]]; then
	warn "The destination folder: \"${DEST_DIR}\" already exists. We will make a backup for you under the same folder."
fi

ring_bell
wait_for_user

if check_ssh; then
	USE_SSH=0
fi

if [[ -d "${DEST_DIR}" ]]; then
	execute "mv" "-f" "${DEST_DIR}" "${DEST_DIR}_$(date +%Y%m%dT%H%M%S)"
fi

prompt "Fetching in progress..."
if [ "$USE_SSH" -eq "1" ]; then
	if is_latest; then
		execute "git" "clone" "-b" "main" "git@github.com:ayamir/nvimdots.git" "${DEST_DIR}"
	else
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION})."
		prompt "Automatically redirecting you to legacy version..."
		execute "git" "clone" "-b" "0.7" "git@github.com:ayamir/nvimdots.git" "${DEST_DIR}"
	fi
else
	if is_latest; then
		execute "git" "clone" "-b" "main" "https://github.com/ayamir/nvimdots.git" "${DEST_DIR}"
	else
		warn "You have outdated Nvim installed (< ${REQUIRED_NVIM_VERSION})."
		prompt "Automatically redirecting you to legacy version..."
		execute "git" "clone" "-b" "0.7" "https://github.com/ayamir/nvimdots.git" "${DEST_DIR}"
	fi
fi

cd "${DEST_DIR}" || return

if [ "$USE_SSH" -eq "0" ]; then
	prompt "Changing default fetching method to HTTPS..."
	sed -i '' -e 's/\[\"use_ssh\"\] \= true/\[\"use_ssh\"\] \= false/g' "./lua/core/settings.lua"
	# The -i argument for sed command is a GNU extension. Compatibility issues need to be addressed in the future.
fi

prompt "Spawning neovim and fetching plugins... (You'll be redirected shortly)"
prompt "If packer failed to fetch any plugin(s), maunally execute \`nvim +PackerSync\` until everything is up-to-date."
cat <<EOS

Thank you for using this set of configuration!
- Project Homepage:
    ${tty_underline}https://github.com/ayamir/nvimdots${tty_reset}
- Further documentation (including executables you ${tty_bold}may${tty_reset} install for full functionality):
    ${tty_underline}https://github.com/ayamir/nvimdots/wiki/Prerequisites${tty_reset}
EOS
wait_for_user

nvim +PackerSync
