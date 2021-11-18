#! /usr/bin/env sh

__numonic_install_darwin() {
	BREWS='zsh'

	for pkg in ${BREWS}; do
		if brew list --versions "${pkg}" 1>/dev/null; then
			print-success "macOS: upgrading ${pkg}..."
			brew upgrade ${pkg} 2>/dev/null || true
			brew link --overwrite ${pkg} 2>/dev/null || true
		else
			print-success "macOS: installing ${pkg}..."
			brew install ${pkg} || true
		fi
	done

	HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

	# set permissions on the site-functions paths
	sudo chmod u=rwx,go=rx "${HOMEBREW_PREFIX}/share/zsh"
	sudo chown "$(whoami)" "${HOMEBREW_PREFIX}/share/zsh"

	sudo chmod u=rwx,go=rx "${HOMEBREW_PREFIX}/share/zsh/site-functions"
	sudo chown "$(whoami)" "${HOMEBREW_PREFIX}/share/zsh/site-functions"

	# test to see if the zsh completion dir is specified
	if [ -n "${ZSH_COMPLETION_DIR:-}" ] && [ -d "${ZSH_COMPLETION_DIR:-}" ]; then

		# set permissions on the script directory
		sudo chmod u=rwx,go=rx "${ZSH_COMPLETION_DIR}"
		sudo chown "$(whoami)" "${ZSH_COMPLETION_DIR}"
	fi

	# remove any cached zsh completion
	rm -f "${HOME}"/.zcompdump* 1>/dev/null 2>&1 || true
}

__numonic_install_darwin
