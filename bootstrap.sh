#! /usr/bin/env sh

set -e

if [ -t 1 ]; then
	FORMAT_CLEAR=$(tput sgr0)	# CLEAR ALL FORMAT
	FORMAT_BOLD=$(tput bold)	# SET BRIGHT/BOLD

	CLR_RED=$(tput setaf 1)		# ANSI RED
	CLR_GREEN=$(tput setaf 2)	# ANSI GREEN
	CLR_YELLOW=$(tput setaf 3)	# ANSI YELLOW

	CLR_SUCCESS="${FORMAT_BOLD}${CLR_GREEN}"
	CLR_WARN="${FORMAT_BOLD}${CLR_YELLOW}"
	CLR_FAIL="${FORMAT_BOLD}${CLR_RED}"
else
	FORMAT_CLEAR=''

	CLR_SUCCESS="\n--------------------------------------------------------------------------------\n"
	CLR_WARN="\n********************************************************************************\n"
	CLR_FAIL="\n################################################################################\n"
fi

__numonic_print_notice()
{
	printf "${1}%s${FORMAT_CLEAR}\n" "$@"
}

__numonic_print_success()
{
	printf "${CLR_SUCCESS}%s${FORMAT_CLEAR}\n" "$@"
}

__numonic_print_warn()
{
	printf "${CLR_WARN}%s${FORMAT_CLEAR}\n" "$@"
}

__numonic_print_fail()
{
	printf "${CLR_FAIL}%s${FORMAT_CLEAR}\n" "$@"
}

alias print-notice='__numonic_print_notice'
alias print-success='__numonic_print_success'
alias print-warn='__numonic_print_warn'
alias print-fail='__numonic_print_fail'

__numonic_update()
{
	GITHUB_TOKEN=${GITHUB_TOKEN:-}
	NUMONIC_TOKEN=${NUMONIC_TOKEN:-}
	NUMONIC_TOKEN=${NUMONIC_TOKEN:-${GITHUB_TOKEN}}
	NUMONIC_CURL_OPT=${NUMONIC_CURL_OPT:-'-s'}
	NUMONIC_COMMIT_REF=${NUMONIC_COMMIT_REF:-"main"}
	NUMONIC_SHELL=${NUMONIC_SHELL:-"bash"}
	NUMONIC_DRY_RUN=${NUMONIC_DRY_RUN:-}

	while :; do
		case $1 in
			-t|--token)
				NUMONIC_TOKEN=$2
				shift
				;;
			-v|--version)
				NUMONIC_COMMIT_REF=$2
				shift
				;;
			-dr|--dry-run)
				NUMONIC_DRY_RUN=1
				;;
			-f|--force)
				rm -rf "${HOME}/.local/numonic/.sha" 1>/dev/null 2>&1
				;;
			--debug)
				set -x
				;;
			?*)
				NUMONIC_SHELL=$1
				;;
			*)
				break
				;;
		esac
		shift
	done

	if [ -n "${NUMONIC_TOKEN:-}" ]; then
		NUMONIC_CURL_OPT="${NUMONIC_CURL_OPT} -H 'Authorization: token ${NUMONIC_TOKEN}'"
	fi

	NUMONIC_SHA_URI="https://api.github.com/repos/automotiveMastermind/numonic/commits/${NUMONIC_COMMIT_REF}"
	NUMONIC_SHA=$(curl "${NUMONIC_CURL_OPT}" "${NUMONIC_SHA_URI}" | grep sha | head -n 1 | sed 's#.*\:.*"\(.*\).*",#\1#')

	# detect if sha could be located
	if [ -z "${NUMONIC_SHA:-}" ]; then
		print-fail "numonic: cannot retrieve SHA of latest version. Are you connected to the internet?"
		return 1
	fi

	NUMONIC_SHA_PATH=${HOME}/.local/numonic/.sha

	# detect if sha file exists
	if [ -f "${NUMONIC_SHA_PATH}" ]; then

		# get the value of the sha file
		NUMONIC_CURRENT_SHA=$(cat "${NUMONIC_SHA_PATH}")

		# print latest version already installed
		if [ "${NUMONIC_SHA}" = "${NUMONIC_CURRENT_SHA}" ]; then
			print-warn \
				"numonic: latest version already installed: ${NUMONIC_SHA}" \
				"  - run update-numonic with the --force flag to reinstall ${CLR_CLEAR}"
			return
		fi
	fi

	if [ -n "${NUMONIC_DRY_RUN:-}" ]; then
		print-warn \
			"numonic: a new version of numonic is available: ${NUMONIC_SHA}" \
			"  - run the update-numonic command line tool to upgrade${CLR_CLEAR}"
		return
	fi

	NUMONIC_INSTALL_URI="https://github.com/automotiveMastermind/numonic/archive/${NUMONIC_COMMIT_REF}.tar.gz"
	NUMONIC_INSTALL_TEMP=$(mktemp -d)

	curl -skLo "${NUMONIC_INSTALL_TEMP}/numonic.tgz" "${NUMONIC_INSTALL_URI}"
	tar --extract \
		--gzip \
		--strip-components=1 \
		--file="${NUMONIC_INSTALL_TEMP}/numonic.tgz" \
		--directory="${NUMONIC_INSTALL_TEMP}"

	"${NUMONIC_INSTALL_TEMP}/install.sh" "${NUMONIC_SHELL}" "${NUMONIC_INSTALL_TEMP}"
}

trap 'print-warn "numonic: terminating update..."; exit 1;' INT

__numonic_update "$@"
