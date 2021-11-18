#! /usr/bin/env sh

set -e

__numonic_install_fedora() {
	sudo_cmd=$(command -v sudo || printf '')
	yum_cmd=$(command -v dnf || command -v yum)
	packages='libxcrypt-compat'

	print-success "fedora: installing ${packages}..."
	# shellcheck disable=SC2086
	"${sudo_cmd}" "${yum_cmd}" install -y ${packages}
}

__numonic_install_fedora
