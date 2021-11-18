#! /usr/bin/env bash

set -e

__numonic_install_brew() {

	# determine if we are on x86
	if [ "$(uname -m)" = "x86_64" ]; then

		# install homebrew using defaults
		__numonic_install_intel

		# move on immediately
		return 0
	fi

	 # install homebrew for apple silicon
	__numonic_install_arm64
}

__numonic_install_intel() {
	print-success '' \
		'##############################################################################' \
		'INSTALLING HOMEBREW FOR INTEL' \
		'##############################################################################' \
	''

	HOMEBREW_PREFIX="/usr/local"
	brew_cmd="${HOMEBREW_PREFIX}/bin/brew"

	if ! command -v ${brew_cmd} 1>/dev/null 2>&1; then
		print-success "installing homebrew..."
		/bin/bash -c "CI=true $(curl -fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/master/install.sh) && ${brew_cmd} config"
	fi

	__numonic_install_darwin "/usr/local/bin/brew"
}

__numonic_install_arm64() {
	print-success '' \
		'##############################################################################' \
		'INSTALLING HOMEBREW FOR APPLE SILICON (arm64e)' \
		'##############################################################################' \
	''

	HOMEBREW_PREFIX="/opt/homebrew"
	brew_cmd="${HOMEBREW_PREFIX}/bin/brew"

	if ! command -v ${brew_cmd} 1>/dev/null 2>&1; then
		print-success "installing homebrew..."
		/bin/bash -c "HOMEBREW_PREFIX=${HOMEBREW_PREFIX} CI=true $(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/master/install.sh) && ${brew_cmd} config"
	fi

	__numonic_install_darwin "arch -arm64e /opt/homebrew/bin/brew"
}

__numonic_install_darwin() {
	print-success '' \
		'##############################################################################' \
		'INSTALLING HOMEBREW PACKAGES' \
		'##############################################################################' \
	''

	brews='git gpg pinentry-mac jq'
	brew_cmd=${1:-"/usr/local/bin/brew"}

	# load the shell env for the current brew
	eval "$(${brew_cmd} shellenv)"

	# disable brew analytics
	${brew_cmd} analytics off

	print-success "macOS: updating homebrew..."
	${brew_cmd} update

	for pkg in ${brews}; do
		if ${brew_cmd} list --versions "${pkg}" 1>/dev/null; then
			print-success "macOS: upgrading ${pkg}..."
			${brew_cmd} upgrade "${pkg}" 2>/dev/null || true
			${brew_cmd} link --overwrite "${pkg}" 2>/dev/null || true
		else
			print-success "macOS: installing ${pkg}..."
			${brew_cmd} install "${pkg}" || true
		fi
	done

	GPG_CONFIG_DIR="$(gpgconf --list-dirs homedir 2>/dev/null || printf '')"

	# test for gpg config
	if [ ! -d "${GPG_CONFIG_DIR}" ]; then

		# create the gpg config directory
		mkdir -p "${GPG_CONFIG_DIR}"

		# set the permissions
		chmod u=rwx,go= "${GPG_CONFIG_DIR}"

		# apply initial defaults
		gpgconf --apply-defaults 1>/dev/null 2>/dev/null || true
	fi

	print-success "macOS: setting git credential helper to use the macOS keychain..."
	git config --global credential.helper osxkeychain

	print-success "macOS: installing starship..."
	curl --fail \
		--silent \
		--show-error \
		--location \
		https://starship.rs/install.sh | bash -s -- --force --bin-dir="${NUMONIC_BIN}" 1>/dev/null
}

__numonic_install_fonts() {

	print-success '' \
		'##############################################################################' \
		'INSTALLING NERD FONT (FIRA CODE)' \
		'##############################################################################' \
	''

	# setup the font dir
	font_dir="${HOME}/Library/Fonts/NerdFonts"

	# create a temp dir for fonts
	temp_dir=$(mktemp -d)

	# download fonts
	curl --fail \
		--silent \
		--show-error \
		--location \
		--output "${temp_dir}/FiraCode.zip" \
		https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip

	# determine if fira code already exists
	if [ -d "${font_dir}" ]; then

		# delete fira code
		rm -rf "${font_dir}" 1>/dev/null 2>&1
	fi

	# ensure the fira code directory
	mkdir -p "${font_dir}" 1>/dev/null 2>&1

	# extract fira code
	unzip "${temp_dir}/FiraCode.zip" 'Fira*.otf' -x '*Windows*' -d "${font_dir}" 1>/dev/null

	# remove temp
	rm -rf "${temp_dir}" 1>/dev/null 2>&1
}

__numonic_install_brew
__numonic_install_fonts
