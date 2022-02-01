#! /usr/bin/env sh

set -e

__numonic_install_arch() {
	sudo_cmd=$(command -v sudo || printf '')
	packages="git gnupg jq unzip"

	print-success "arch: updating software repositories..."
	"${sudo_cmd}" pacman --sync --refresh

	print-success "arch: installing ${packages}..."
	# shellcheck disable=SC2086
	"${sudo_cmd}" pacman --sync --needed --noconfirm ${packages}

	print-success "arch: removing unnecessary dependencies..."
	"${sudo_cmd}" pacman --remove --unneeded $(pacman --query --deps --unrequired --quiet) 2>/dev/null || print-success "arch: nothing to remove"
}

__numonic_install_arch
