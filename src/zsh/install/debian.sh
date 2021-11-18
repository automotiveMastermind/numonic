#! /usr/bin/env sh

set -e

__numonic_install_debian() {
	SUDO=$(command -v sudo || printf '')
	PACKAGES="zsh"

	print-success "debian: updating software repositories..."
	"${SUDO}" apt update --yes

	print-success "debian: installing ${PACKAGES}..."
	# shellcheck disable=SC2086
	"${SUDO}" apt install --yes ${PACKAGES}

	print-success "debian: removing unnecessary dependencies..."
	"${SUDO}" apt autoremove -y
}

__numonic_install_debian
