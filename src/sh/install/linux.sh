#! /usr/bin/env sh

set -e

__numonic_install_linux() {

	gpg_config_dir="$(gpgconf --list-dirs | grep ^homedir)"
	gpg_config_dir=${gpg_config_dir#*\:}

	# test for gpg config
	if [ ! -d "${gpg_config_dir}" ]; then

		# create the gpg config directory
		mkdir -p "${gpg_config_dir}"

		# set the permissions
		chmod u=rwx,go= "${gpg_config_dir}"

		# apply initial defaults
		gpgconf --apply-defaults 1>/dev/null 2>/dev/null || true
	fi

	print-success "linux: installing starship..."
	curl --fail \
		--silent \
		--show-error \
		--location \
		https://starship.rs/install.sh | bash -s -- --force --bin-dir="${NUMONIC_BIN}" 1>/dev/null

	print-success "linux: upgrading fira code font..."
	font_dir="${NUMONIC_SHARE}/fonts/NerdFonts"
	temp_dir=$(mktemp -d)

	# download fonts
	curl --fail \
		--silent \
		--show-error \
		--location \
		--output "${temp_dir}"/FiraCode.zip \
		https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip

	# determine if fira code already exists
	if [ -d "${font_dir}" ]; then

		# delete fira code
		rm -rf "${font_dir}" 1>/dev/null 2>&1
	fi

	# make sure the font dir exists
	mkdir -p "${font_dir}" 1>/dev/null

	# extract fira code
	unzip "${temp_dir}"/FiraCode.zip 'Fira*.otf' -x '*Windows*' -d "${font_dir}" 1>/dev/null

	# remove temp
	rm -rf "${temp_dir}" 1>/dev/null 2>&1
}

__numonic_install_linux
