#! /usr/bin/env sh

__numonic_install_centos() {
	SUDO=$(command -v sudo || printf '')
	YUM=$(command -v dnf || command -v yum)
	PACKAGES='zsh'

	print-success "centos: installing ${PACKAGES}..."
	# shellcheck disable=SC2086
	"${SUDO}" "${YUM}" install -y ${PACKAGES}
}

__numonic_install_centos
