#! /usr/bin/env sh

set -e

SHELL_NAME=${1:-'bash'}

./install.sh "${SHELL_NAME}"

SHELL=${SHELL_NAME}

if [ -f /opt/homebrew/bin/"${SHELL_NAME}" ]; then
	SHELL=/opt/homebrew/bin/${SHELL_NAME}
elif [ -f /usr/local/bin/"${SHELL_NAME}" ]; then
	SHELL=/usr/local/bin/${SHELL_NAME}
fi

# shellcheck disable=SC2016
exec "${SHELL}" -lc 'cat ${NUMONIC_HOME}/.sha'
