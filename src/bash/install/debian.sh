#! /usr/bin/env sh

set -e

__numonic_install_debian() {
	sudo_cmd=$(command -v sudo || printf '')
	packages='bash bash-completion'

	print-success "debian: updating software repositories..."
	"${sudo_cmd}" apt update --yes

	print-success "debian: installing ${packages}..."
	# shellcheck disable=SC2086
	"${sudo_cmd}" apt install --yes ${packages}

	print-success "debian: removing unnecessary dependencies..."
	"${sudo_cmd}" apt autoremove -y
}

__numonic_install_debian
