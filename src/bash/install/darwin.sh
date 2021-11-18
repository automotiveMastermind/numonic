#! /usr/bin/env sh

__numonic_install_darwin() {
	brews='bash bash-completion@2'

	for pkg in ${brews}; do
		if brew list --versions "${pkg}" 1>/dev/null; then
			print-success "macOS: upgrading ${pkg}..."
			brew upgrade "${pkg}" 2>/dev/null || true
			brew link --overwrite "${pkg}" 2>/dev/null || true
		else
			print-success "macOS: installing ${pkg}..."
			brew install "${pkg}" || true
		fi
	done
}

__numonic_install_darwin
