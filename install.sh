#! /usr/bin/env sh

set -e

NUMONIC_SCRIPT_DIR="${2:-$(cd -- "$(dirname -- "$0")" && pwd -P)}"

export HOMEBREW_NO_AUTO_UPDATE=1

export NUMONIC_LOCAL="${HOME}"/.local
export NUMONIC_HOME="${NUMONIC_LOCAL}"/numonic
export NUMONIC_SHARE="${NUMONIC_LOCAL}"/share
export NUMONIC_BIN="${NUMONIC_LOCAL}"/bin

# source the colors
. "${NUMONIC_SCRIPT_DIR}"/src/sh/scripts/eval/set-colors
export PATH="${NUMONIC_SCRIPT_DIR}/src/sh/scripts:${PATH}"

__numonic_prerequisites() {

	# detect platform
	UNAMES=$(print-unames)

	# iterate over each uname
	for UNAME in ${UNAMES}; do

		# find the install path for the uname
		UNAME_PATH="${NUMONIC_SCRIPT_DIR}"/src/sh/install/"${UNAME}".sh

		# determine if the installer for the uname does not exist
		if [ ! -f "${UNAME_PATH}" ]; then
			# test the next uname
			continue
		fi

		# install the prerequisites
		print-success "numonic: install platform prerequisites for: ${UNAME}"
		. "${UNAME_PATH}"
	done
}

__numonic_install() {

	# get the current timestamp as a backup path
	NOW=$(date +'%Y-%M-%d-%H%M%S')
	BACKUP_PATH="${NUMONIC_LOCAL}"/backup/numonic/"${NOW}"

	# script the backup path
	print-success "numonic: creating backup path: ${BACKUP_PATH}"
	mkdir -p "${BACKUP_PATH}" 1>/dev/null 2>&1 || true

	# determine if numonic already exists
	if [ -d "${NUMONIC_HOME}" ]; then

		# find all non-user and backup paths and back them up
		print-success "noominic: creating backup from: ${NUMONIC_HOME}"
		find "${NUMONIC_HOME}" -mindepth 1 -maxdepth 1 -type d \
			-exec mv {} "${BACKUP_PATH}" \;
	fi

	# backup the templates
	for TEMPLATE in "${NUMONIC_SCRIPT_DIR}"/template/*; do
		TEMPLATE_NAME=$(basename "${TEMPLATE}")
		TEMPLATE_PATH="${HOME}/.${TEMPLATE_NAME}"

		if [ -f "${TEMPLATE_PATH}" ]; then
			print-success "numonic: backing up ${TEMPLATE_NAME}"
			cp "${TEMPLATE_PATH}" "${BACKUP_PATH}/${TEMPLATE_NAME}"

			if [ "${TEMPLATE_NAME}" = "pam_environment" ]; then
				continue
			fi
		fi

		cp "${TEMPLATE}" "${TEMPLATE_PATH}"
	done

	# determine if the user bin does not exist
	if [ ! -d "${NUMONIC_HOME}" ]; then
		print-success "numonic: installing at: ${NUMONIC_HOME}"
		mkdir -p "${NUMONIC_HOME}"
	fi

	if [ ! -d "${NUMONIC_BIN}" ]; then
		print-success "numonic: creating bin at: ${NUMONIC_BIN}"
		mkdir -p "${NUMONIC_BIN}"
	fi

	if [ ! -d "${NUMONIC_SHARE}" ]; then
		print-success "numonic: creating share at: ${NUMONIC_SHARE}"
		mkdir -p "${NUMONIC_SHARE}"
	fi

	# install prerequisites
	__numonic_prerequisites

	# find all non-user scripts and copy them
	find "${NUMONIC_SCRIPT_DIR}"/src -mindepth 1 -maxdepth 1 -type d \
		-not -name 'local' \
		-exec cp -Rf {} "${NUMONIC_HOME}" \;

	local_dir="${NUMONIC_SCRIPT_DIR}"/src/local

	# find all of the user initialization files
	find "${local_dir}" -type f | while read -r item; do

		# get the relative path of the item within local dir
		item_rel=${item##*"${local_dir}"}

		# get the item to path
		item_to="${NUMONIC_LOCAL}/${item_rel}"

		# get the absolute final path of the item
		item_dir=$(dirname "${item_to}")

		# get the item name
		item_name=$(basename "${item}")

		# determine if the item path does not exist
		if [ ! -d "${item_dir}" ]; then

			# create the user path
			mkdir -p "${item_dir}"
		fi

		# determine if the item is the keeper
		if [ "${item_name}" = ".gitkeep" ]; then

			# move on immediately
			continue
		fi

		# determine if the item does not exist
		if [ ! -f "${item_to}" ]; then

			# copy the user item
			cp "${item}" "${item_to}"
		fi
	done


	NUMONIC_SHA=$(cat "${NUMONIC_SCRIPT_DIR}"/VERSION)
	NUMONIC_SHA_PATH="${HOME}"/.local/numonic/.sha

	printf '%s\n' "${NUMONIC_SHA}" > "${NUMONIC_SHA_PATH}"

	# get the requested shell
	NUMONIC_SHELL="${1:-${NUMONIC_SHELL:-${SHELL##*/}}}"

	# lowercase the requested shell
	NUMONIC_SHELL=$(printf '%s' "${NUMONIC_SHELL}" | tr '[:upper:]' '[:lower:]')

	# determine if the shell is one of the supported shells
	if [ "${NUMONIC_SHELL}" != "zsh" ] && [ "${NUMONIC_SHELL}" != "bash" ]; then

		# default to zsh
		NUMONIC_SHELL="zsh"
	fi

	# add the shell scripts to the path (within the install process)
	export PATH="${NUMONIC_HOME}/sh/scripts:${NUMONIC_HOME}/${NUMONIC_SHELL}/scripts:${PATH}"

	# use the correct shell
	use-shell "${NUMONIC_SHELL}"

	# open the changelog url
	open-url --quiet "https://github.com/automotivemastermind/numonic/blob/${NUMONIC_SHA}/CHANGELOG.md"
}

# print a warning
trap 'print-warn "numonic: terminating install..."; exit 1;' INT

# determine if sudo is available
if command -v sudo 1>/dev/null 2>&1; then
	print-warn 'numonic: establishing sudo (you may be prompted for credentials)...'
	sudo printf '%s\n' ''
	print-success "numonic: sudo enabled"
fi

# invoke the installer
__numonic_install "$@"
