#!/bin/bash

DIR="$HOME/.config/nvim"

is_latest() {
	version=$(nvim --version | head -n1 | sed -e 's|^[^0-9]*||' -e 's| .*||')
	if [[ "$version" == "0.8.0" ]]; then
		return 0
	else
		return 1
	fi
}

install() {
	if [[ -d "$DIR" ]]; then
		mv ~/.config/nvim ~/.config/nvim_bak
	fi
	git clone git@github.com:ayamir/nvimdots.git ~/.config/nvim
	cd ~/.config/nvim || return
	if is_latest; then
		git switch 0.8
	else
		git switch 0.7
	fi
	nvim +PackerSync
}

install
