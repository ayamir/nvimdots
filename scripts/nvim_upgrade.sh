#!/usr/bin/env bash
# shellcheck disable=SC2059,SC2154
set -e
set -o pipefail

# string formatters
if [[ -t 1 ]]; then
    tty_escape() { printf "\033[%sm" "$1"; }
else
    tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_green="$(tty_mkbold 32)"
tty_blue="$(tty_mkbold 34)"
tty_reset="$(tty_escape 0)"

######################################################################
#                       Update Neovim nightly                        #
######################################################################
NVIM_DIR=$HOME/tools/nvim
NVIM_SRC_NAME=$HOME/packages/nvim-linux64.tar.gz
NVIM_LINK="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"

printf "Update ${tty_blue}Neovim nightly...${tty_reset}\n"
if [[ -f $NVIM_SRC_NAME ]]; then
    rm "$NVIM_SRC_NAME"
fi
if [[ -d $NVIM_DIR ]]; then
    rm -r "$NVIM_DIR"
    mkdir -p "$NVIM_DIR"
    mkdir -p "$HOME/packages"
fi
wget "$NVIM_LINK" -O "$NVIM_SRC_NAME"
echo "Extracting Neovim"
tar zxvf "$NVIM_SRC_NAME" --strip-components 1 -C "$NVIM_DIR"
printf "${tty_blue}Neovim${tty_reset} updated to ${tty_green}nightly${tty_reset}.\n"
